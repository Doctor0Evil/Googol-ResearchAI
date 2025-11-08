% precision_math
% Calculates a quantum precision metric for a given state and observable.
% Safe for public superintelligence ops, with runtime checks for state validity.
function prec = precision_math(state, observable)
    % state: Either a normalized (complex) state vector OR a density matrix (Hermitian, PSD, trace=1)
    % observable: Hermitian matrix or binary projector corresponding to the precision-defining observable

    validateattributes(observable, {'double'}, {'square'}, mfilename, 'observable');
    n = size(observable,1);

    % Auto-detect: pure state vector
    if isvector(state)
        state = state(:); % force column vector
        if ~all(size(state) == [n,1])
            error('State vector dimension does not match observable.');
        end
        % Precision = <psi|O|psi>
        prec = real(state' * observable * state);
    else
        % Expecting a density matrix
        if ~isequal(size(state), [n,n])
            error('Density matrix dimension does not match observable.');
        end
        if abs(trace(state)-1) > 1e-10 || ~ishermitian(state)
            error('Density matrix not normalized or not Hermitian.');
        end
        % Precision = Tr[rho O]
        prec = real(trace(state * observable));
    end
    % Clamp into [0,1] if observable is a projector, else allow any real value
    if isequal(observable, observable') && ...
            all(abs(eig(observable) - round(eig(observable))) < 1e-10) && ...
            all((eig(observable) == 0) | (eig(observable) == 1))
        % Projector: Valid probability
        prec = min(max(prec,0),1);
    end
end

% Example with a Bell state (|00> + |11>)/sqrt(2), measuring |00><00|
% psi = [1;0;0;1]/sqrt(2);
% projector = zeros(4); projector(1,1) = 1; % |00><00|
% precision = precision_math(psi, projector)
