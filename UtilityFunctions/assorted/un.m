function X1=un(X)

%	This function takes in a vector (or a matrix) , and returns unique values (or rows). NaNs (and rows with NaNs) are removed.
%	 Currently has a major bug; if supplied a matrix with one row, it
%	 screws up and treats it as a vector. Fix at some point; other
%	 functions may crash as a result...aaargh.
%    X1=un(X)

% if column vector, make row vector

if size(X,1)>1&size(X,2)==1, X=X';end

% effectively returns unique(x(~isnan(x)))

if size(X,1)==1
X1=unique(X(~isnan(X)));
elseif size(X,1)>1

        nanrow=nan*ones(1,size(X,1));
        for ind=1:size(X,2)
            nanrow(isnan(X(:,ind)))=1;
        end

        X1=unique(X(nanrow~=1,:),'rows');
        
end