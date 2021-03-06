function [R]=Prediction_ScanMatching_v1(R)
%
%state, P and dis are inputs of the function to perform prediction.
%The function returns the new state X and its uncertainty P

state = R.state.x;
P= R.state.P;

dis.pos = R.con.u;
dis.cov = R.con.U;

%--RENAME THE STATE VARS---------------------------------------------------
x = state(1);
y = state(2);
% th = 0;

x1 = dis.pos(1);
y1 = dis.pos(2);
th1 = normAngle(dis.pos(3));
Q1 = dis.cov;

% x2 = dis.pos(1);
% y2 = dis.pos(2);
% th2 = normAngle(dis.pos(3));
% Q2 = dis.cov;

tamany = length(state)-3;

%--PREDICTION--------------------------------------------------------------

%Is the previous position plus the displacement (all should referenced in the same frame)
X = [x + x1;
     y + y1;
     state(3) +  th1];
       
%The rest of the state (poses) is constant and doesn't changes
X=[X; state(4:end)];       

%Matrix with respect to state vector X 
A=[ 1, 0, 0; 
    0, 1, 0; 
    0, 0, 0 ];

%Matrix with respect to new displacement            
B=[ 1, 0, 0; 
    0, 1, 0; 
    0, 0, 1 ];

%Build the Jacobians
J1=sparse(blkdiag(A, eye(tamany)));
J2=sparse([B;zeros(tamany,3)]);

%Uncertainty update
P = J1*P*J1' + J2*Q1*J2';

R.state.x=X;
R.state.P=P;
