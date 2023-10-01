
function delta = crout_solver(A, b)


    % for checking
    % A= [1 1 1;
    %     4 3 -1;
    %     3 5 3];
    % 
    % b=[1 6 4];
    % 
    n = length(A);
    
    %getting decomposable matric using crout algorithm
    for j = 1:n
        for k = j:n % for column
            sum=0;
            for i=1:j-1
                sum = sum + A(k,i)*A(i,j);
            end
            A(k,j) = A(k,j) - sum; % replacing within A
        end
    
        for k=j+1:n % for row
            sum =0;
            for i=1:j-1
                sum = sum + A(j,i)*A(i,k);
    
            end
            A(j,k) = 1/A(j,j)*(A(j,k) - sum); %replacing within A
        end
    end
    
    % Decomposing A to L and U
    U = zeros(n);
    L = zeros(n);
    for i = 1:n
        for j = i:n % for upper triangular matrix U
            if(i==j)
                U(i,j) = 1; % setting diagonal of U to 1
            else
                U(i,j) = A(i,j);
            end
        end
        for j = 1:i  % for lower triangular matrix L
            L(i,j) = A(i,j);
        end
    end
    
    
    %%%%% forward substitution %%%%%%%%
    % getting Y
    % LUX=B
    % LY = B where UX = Y
    
    y = zeros(n,1);
    
    for i = 1:n
        sum =0;
        for j = 1: i-1
            sum = sum+ L(i,j)*y(j);
        end
        y(i) = (b(i)-sum)/L(i,i);
    end
    
    %%%backward substitution %%%%%%%
    %getting X
    %UX = Y
    x = zeros(n,1);
    for i = n:-1:1
        sum =0;
        for j = i+1:n
            sum = sum + U(i,j)*x(j);
        end
        x(i) = (y(i) - sum)/U(i,i);
    end
    delta = x;
end



       

 


