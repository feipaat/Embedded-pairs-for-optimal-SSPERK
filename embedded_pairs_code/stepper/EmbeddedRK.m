classdef EmbeddedRK < handle
    
    properties
        tFinal;
        naccpt = 0;
        nrejct = 0;
        reject = 0;
        oldT = 0;
        dtMax;
        posneg;
        nfcn = 0;
        nstep = 0;
        bhat; % embedding weight vector
        rk;
        isEmbedded;
        name;
        t = [];
        stepSize = [];
        status = [];
        lastStepRejected;
    end
    
    properties
        fac = 0.9;
        facMin = 0.1;
        facMax = 5;
        MAXFAC;
    end

    properties
    exactError;
    isExactErrorSet = false;
    end

    properties %(Access = protected)%(Access = private)
        isVariableStep = false;
        rejectedStep = 0;
        acceptedStep = 0;
        order;
        absTol;% absolute tolerance (used in Embedded-RK);
        relTol;% relative tolerance (used in Embedded-RK)
        incrFac;
        decrFac;
        safe;
        fac1;% = 0.2; % facMin
        fac2;% = 10.0; % facMax;
        beta_;
        expo1;
        facc1;
        facc2;
        facold = 1.0E-4;
        phat; % embedding order
        minStepSize;
        maxStepSize;
        safetyFactor;
        %         stepSizeControl;
    end

    properties%(Access = protected)
        initDt;
        t_ = 0;
        badDt_;
        lte = 0;
        rejectedDt_ = NaN;
        rejectedLastStep_ = false;
        preditedStepSize_ = NaN; % need to fix this
        fac11;
        last = 0;
    end

    properties
        stepController;
        k = [];
        err_old = [];
    end
    
    methods
        function obj = EmbeddedRK(varargin)
            
            inpPar = inputParser;
            inpPar.KeepUnmatched = true;
            
            addParameter(inpPar, 'RungeKutta', []);
            addParameter(inpPar,'name',[]);
            addParameter(inpPar, 'RelativeTolerance', 1e-7);
            addParameter(inpPar, 'AbsoluteTolerance', 1e-7);
            addParameter(inpPar, 'MinStepSize',1e-10);
            addParameter(inpPar, 'MaxStepSize',[]);
            addParameter(inpPar, 'FacMax',5);
            addParameter(inpPar, 'FacMin',0.1);
            addParameter(inpPar, 'SafetyFactor', 0.9);
            addParameter(inpPar, 'InitialStepSize',1e-4);
            addParameter(inpPar, 'VariableStepSize', false);
            addParameter(inpPar, 'Tfinal', 1);
            addParameter(inpPar, 'Beta', 0.04);
            addParameter(inpPar, 'Safety', 0.9);
            addParameter(inpPar, 'TInit', 0);
            addParameter(inpPar, 'Controller', 'I'); % ['I', 'ExplicitGustafsson']
            
            inpPar.parse(varargin{:});
            
            obj.rk = inpPar.Results.RungeKutta;
            obj.isEmbedded = true; % using adaptive step
            obj.order = min(obj.rk.p, obj.rk.phat); % order of the method
            obj.t = inpPar.Results.TInit;
            obj.absTol = inpPar.Results.AbsoluteTolerance;
            obj.relTol = inpPar.Results.RelativeTolerance;
            obj.minStepSize = inpPar.Results.MinStepSize;
            obj.maxStepSize = inpPar.Results.MaxStepSize;
            obj.safetyFactor = inpPar.Results.SafetyFactor;
            obj.name = inpPar.Results.name;
            obj.beta_ = inpPar.Results.Beta;
            obj.safe = inpPar.Results.Safety;
            obj.fac1 = inpPar.Results.FacMin;
            obj.fac2 = inpPar.Results.FacMax;
            obj.tFinal = inpPar.Results.Tfinal;
            obj.MAXFAC = obj.facMax;
                        
            if strcmpi(inpPar.Results.Controller, 'i') %I controler is the default
                obj.stepController = @obj.IControler;
                obj.k = 1;
                obj.err_old = 1;
            elseif strcmpi(inpPar.Results.Controller, 'ExplicitGustafsson')
                obj.k = [0.376; 0.268];
                obj.err_old = [1; 1];
                obj.stepController = @obj.ExpGust;
            elseif strcmpi(inpPar.Results.Controller, 'pi')
                obj.k = [0.8; 0.31];
                obj.stepController = @obj.PIControler;
                obj.err_old = [1; 1];
            elseif strcmpi(inpPar.Results.Controller, 'pid')
                obj.k = [0.58; 0.21; 0.1];
                obj.stepController = @obj.PIDControler;
                obj.err_old = [1; 1; 1];
            else
                error(sprinft('%s: not yet recognized. Valid options are I/ExplicitGustafsson',...
                    inpPar.Results.Controller));
            end
            
            % set maximum step size allow
            if isempty(obj.maxStepSize)
                obj.dtMax = obj.tFinal - obj.t;
            else
                obj.dtMax = obj.maxStepSize;
            end
            
            % just to make sure everything is starting fresh;
            obj.resetInitCondition(inpPar.Results.AbsoluteTolerance, ...
                inpPar.Results.RelativeTolerance);
            
        end %EmbeddedRK (contructor)
        
        function obj = sett(obj, in)
            obj.t = [obj.t, in];
        end
        
        function obj = setexactError(obj, val)
            obj.exactError = val;
            obj.isExactErrorSet = true;
        end
        
        
        function summary(obj, varargin)
            
            if isempty(varargin)
                fid = 1;
            else
                fid = varargin{1};
            end
            
            if ~obj.isExactErrorSet
                fprintf(fid, '%15s: rtol= %12.2e, atol= %12.2e, fcn = %6d, step = %6d, accpt = %6d, reject = %6d\n',...
                    obj.name, obj.relTol, obj.absTol, obj.nfcn, obj.nstep, obj.naccpt, obj.nrejct);
            else
                fprintf(fid, '%15s: rtol= %12.2e, atol= %12.2e, fcn = %6d, step = %6d, accpt = %6d, reject = %6d, error = %12.5e\n',...
                    obj.name, obj.relTol, obj.absTol, obj.nfcn, obj.nstep, obj.naccpt, obj.nrejct, obj.exactError);
            end
        end
        
        function dt = startingStepSize(obj)
            % Solving Ordinary Differential Equation I - nonstiff
            % Hairer. pg. 169. Starting Step Size Algorithm
            
            err_fun = @(x, sc_i) sqrt(  sum(((x./sc_i).^2))/length(x)  );
            % a.)
            k1 = obj.L(obj.t, obj.u0);
            sci = obj.absTol + abs(obj.u0)*obj.relTol;
            d0 = err_fun(obj.u0, sci);
            d1 = err_fun(k1, sci);
            
            % b.) first guess for the step size
            if (d0 < 1e-6 || d1 < 1e-6)
                h0 =1e-6;
            else
                h0 = 0.01*(d0/d1);
            end
            
            % c.)
            y1 = obj.u0 + h0*obj.L(obj.t+h0, obj.u0);
            k2 = obj.L(obj.t + h0, y1);
            
            % d.) an estimate of the second derivative
            d2 = (k2 - k1);
            d2 = err_fun(d2, sci)/h0;
            
            % e. )
            max_d1_d2 = max(d1, d2);
            if max_d1_d2 <= 1e-5
                h1 = max(1e-6, 1e-3*h0);
            else
                h1 = (0.01/max_d1_d2)^(1/(obj.p+1));
            end
            
            dt = min(100*h0, h1);
            obj.nextDt = dt;
            obj.nfcn = 2;
        end
        
        function resetInitCondition(obj, atol, rtol)
            
            obj.t = 0.0;
            
            obj.relTol = rtol;
            obj.absTol = atol;
            obj.nfcn = 0;
            obj.last = 0;
            obj.naccpt = 0;
            obj.nrejct = 0;
            obj.reject = 0;
            obj.oldT = 0;
            obj.nfcn = 0;
            obj.nstep = 0;
            obj.lastStepRejected = false;
        end
        
    end
    
    methods %( Access = protected )
        
        function sk = sci_fun(obj, y, yhat)
            sk = obj.absTol + obj.relTol * max(abs(y), abs(yhat));
        end
        
        function [hnew, stepSizeControlStatus] = stepSizeControl(obj, time , dt,  y, yhat)
            % Automatic Step Size Control
            % Hairer. Solving ODE I. pg. 167
            
            obj.dtMax = abs(obj.tFinal - time);
            
            % mark that a step has been taken
            obj.nstep = obj.nstep + 1;
            
            % TODO: this is for explicit method
            obj.nfcn = obj.nfcn + (obj.rk.s -1);
            
            obj.stepSize = [obj.stepSize; dt];
            lte_ = abs(y - yhat);
            obj.lte = [obj.lte, norm(lte_, 2)];
            
            sk = obj.sci_fun(y, yhat);
            err = norm(lte_./sk,inf);
            
            
            % call choice of step-control algorithm here
            beta = obj.stepController(err, dt);
                        
            alpha = max(obj.facMin, obj.fac * beta);
            alpha = min(obj.facMax, alpha);
            hnew = dt*alpha;
                        
            if (err - 1) < eps(16) % accept the solution
                obj.status = [obj.status; true];
                obj.naccpt = obj.naccpt + 1;
                obj.oldT = obj.t;
                
                if (obj.lastStepRejected)
                    % if last step was rejected
                    hnew = min(abs(hnew), abs(dt));
                else
                    obj.facMax = obj.MAXFAC;
                end
                    
%                 if (abs(hnew - obj.dtMax) < 1e-10)
%                     % should not take more than the maximum step-size
%                     hnew = abs(obj.dtMax);
%                 end
                
                obj.lastStepRejected = false;
            else % reject the solution
                obj.status = [obj.status; false];
                obj.lastStepRejected = true;
                obj.facMax = 0.9;
                
                if (obj.naccpt >= 1)
                    obj.nrejct = obj.nrejct + 1;
                end
            end
            
            hnew = min(hnew, obj.dtMax);
            
            if abs(hnew) < 1e-14
                error('Step-Size too small');
            end
            
            stepSizeControlStatus = obj.status(end);
        end
        
    end
    
    methods (Access = protected)

    function h_acc = IControler(obj, err, dt)
        %I Controller algorithm
        k1 = -obj.k/obj.order;
        e1 = max(err, 1e-10);
        h_acc = (e1^k1);
    end %IControler

    function h_acc = PIControler(obj, err, dt)
    	% PI Controller algorith
        if obj.nstep == 1
            obj.err_old(1) = err;
        else
            obj.err_old(2) = obj.err_old(1);
            obj.err_old(1) = err;
        end
        k1 = -obj.k(1)/obj.order;
        k2 = obj.k(2)/obj.order;
        e1 = max(obj.err_old(1), 1e-10);
        e2 = max(obj.err_old(2), 1e-10);
        h_acc = (e1^k1)*(e2^k2);
        obj.err_old(2) = err;
        hnew = h_acc;
    end %PIControler

    
    function h_acc = PIDControler(obj, err, dt)
    	% PID Controller algorithm
        if obj.nstep == 1
            obj.err_old(1) = err;
        elseif obj.nstep == 2
            obj.err_old(2) = obj.err_old(1);
            obj.err_old(1) = err;
        else
            obj.err_old(3) = obj.err_old(2);
            obj.err_old(2) = obj.err_old(1);
            obj.err_old(1) = err;
        end
        k1 = -obj.k(1)/obj.order;
        k2 = obj.k(2)/obj.order;
        k3 = -obj.k(3)/obj.order;
        e1 = max(obj.err_old(1), 1e-10);
        e2 = max(obj.err_old(2), 1e-10);
        e3 = max(obj.err_old(3), 1e-10);
        h_acc = (e1^k1)*(e2^k2)*(e3^k3r);
        hnew = h_acc;
    end %PIDControler

    function hnew = ExpGust(obj, err, dt)
        % Explicit Gustafsson controller

        if obj.nstep == 1 % on the first step
            k1 = -1/obj.order;
            e1 = max(err, 1e-10);
            h_acc = (err^k1);
            obj.err_old = err;
        else % on the subsequent steps
            k1 = -obj.k(1)/obj.order;
            k2 = obj.k(2)/obj.order;
            scaled_err = (err/obj.err_old);
            e1 = max(err, 1e-10);
            h_acc = (e1^k1)*(scaled_err^k2);
            obj.err_old = err;
        end
        hnew = h_acc;
    end
        
        function hnew = StabilizedLund(obj, dt)
            %/* computation of hnew */
            obj.fac11 = err.^(obj.expo1);
            
            % /* Lund-stabilization */
            fac = obj.fac11/(obj.facold.^(obj.beta_));
            
            % /* we require fac1 <= hnew/h <= fac2 */
            fac = max(obj.facc2, min(obj.facc1, fac/obj.safe));
            hnew = dt / fac;
        end
    end
end
