function [ theta_lat, theta_lon ] = para_kriging2( X, geo_loc, beta, Dims )
%PARA_KRIGING2 Summary :parameterize covariance matrix: 
% W_{i,j} = exp(-theta_lat(i,j)|lat_i-lat_j| )  +  exp(-theta_lon(i,j)|lon_i-lon_j| )
%   Detailed explanation goes here

maxIter = 20;
maxGDIter  = 50;
eta = 0.2;
nSamples = size(X{1},2);
nTasks = length(X);
nModes = length(Dims);

% intialize 

theta_lat = randi(10,Dims);
theta_lon = randi(10,Dims);

Z = cell(nModes,1);
C = cell(nModes,1);

for n = 1: nModes
    Z{n} = zeros(Dims);
    C{n} = zeros(Dims);
end



for iter = 1:maxIter
    CnSum = zeros(Dims);
    ZnSum = zeros(Dims);
    for n = 1:nModes
        CnSum = CnSum +  C{n};
        ZnSum = ZnSum + Z{n};
    end
    % Solve theta_lat  with gradient descend 
    for t = nTasks
        theta_lat_t = theta_lat(:,:,t);
        X_t = X{t};
        for GDiter = 1:maxGDIter
             
            grad = 2*nSamples*pinv(theta_lat_t') -  (theta_lat_t*theta_lat_t')\X_t*X_t'/(theta_lat_t*theta_lat_t')*2*theta_lat_t; 
            grad = grad -( CnSum (:,:,t) + beta* ZnSum(:,:,t)  ) ;
            grad = grad + nModes * beta * W(:,:,t);
            theta_lat_t= theta_lat_t- eta*grad;

        end
        W(:,:,t)  = theta_lat_t;

    end
    
    % Solve theta_lon  with gradient descend 
    for t = nTasks
        theta_lon_t = theta_lat(:,:,t);
        X_t = X{t};
        for GDiter = 1:maxGDIter
             
            grad = 2*nSamples*pinv(theta_lon_t') -  (theta_lon_t*theta_lon_t')\X_t*X_t'/(theta_lon_t*theta_lon_t')*2*theta_lon_t; 
            grad = grad -( CnSum (:,:,t) + beta* ZnSum(:,:,t)  ) ;
            grad = grad + nModes * beta * W(:,:,t);
            theta_lon_t= theta_lon_t- eta*grad;

        end
        theta_lon(:,:,t)  = theta_lon_t;

    end
    % need to change to regualize on theta_lat and theta_lon
    for t = 1:nTasks
        for i = 1:nLocs
            for j = 1:nLocs
                W(i,j,t) = exp(-theta_lat(i,j,t)*abs(geo_loc(i,1)-geo_loc(j,1)));
                W(i,j,t )= W(i,j,t) + exp(-theta_lon(i,j,t)*abs(geo_loc(i,2)-geo_loc(j,2)) );
                
            end
        end
    end
    % Optimizing over B    
    for n=1:nModes    
        W_n= unfld(W, n);
        Cn_n = unfld(C{n},n);
        Zn_n=shrink(W_n-1/beta*Cn_n, 1/beta);
        Z{n} = fld2(Zn_n,n, Dims);
    end
    
    
    
    
     % Optimizing over C  
    for n=1:nModes     
        C{n}=C{n}-beta*(W-Z{n});
    end
end
end

