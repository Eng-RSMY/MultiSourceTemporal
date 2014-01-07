This code requires the tensor toolbox from SANDIA (found at http://www.sandia.gov/~tgkolda/TensorToolbox/index-2.5.html). The code I send is an improved version with respect to the one used in the paper so that now is more efficient.
 
I describe its use below:
 
 
The main function is MLMTL_Convex( X, Y, indicators, beta, lambda, outerNiTPre, thresholdPre, groundW ) 

 
Let us cosider an example (the restaurant dataset), where we have 138 users x 3 aspects = 414 tasks, and the dimensionality of the data is 45. Then:
 .- X, Y are cells of size 1 x 414, where in X{i} and Y{i} we have the instances and labels for task i. The size of X{i} is dimensionality of data x number of instances for task i, and Y{i} is a column vector with as many elements as the number of instances.
 .- indicators is a vector denoting the size of the weight tensor, where the first number should be the dimensionality of the data, and the others should be the numbers of elements for each mode. In our case it should be [45, 3, 138] (if the way we have introduced the data in X and Y is such that the outer loop is for users (138), and the inner loop for aspects (3), see code below).
 .- beta is a hyperparameter (see paper for more information)
 .- lambda is the weight of the regularizer (see paper for more information).
 .- outerNiTPre: maximum number of iterations. 100 is usually enough.
 I do not use the remaining two parameters in the last version of the code.


 Let us assume that indicesChosen and indicesNoChosen contain the set of indices of instances belonging to the training and test set respectively. Then the code would be:

 [nAttrs nInstances]=size(X);
 nUsers=max(instanceIndices(1,:));
 nMarks=max(instanceIndices(2,:));
 indicators=[nAttrs, nMarks, nUsers];

 taskCounter=1;
 for i=1:nUsers
 indicesI=find(instanceIndices(1,:)==i);
 indicesIChosen=intersect(indicesI, indicesChosen);
 indicesINoChosen=intersect(indicesI, indicesNoChosen);

 for j=1:nMarks
 indicesJ=find(instanceIndices(2,:)==j);
 indicesIJChosen=intersect(indicesJ, indicesIChosen);
 indicesIJNoChosen=intersect(indicesJ, indicesINoChosen);
 trainXCell{taskCounter}=X(:,indicesIJChosen);
 trainYCell{taskCounter}=Y(indicesIJChosen)';
 testXCell{taskCounter}=X(:,indicesIJNoChosen);
 testYCell{taskCounter}=Y(indicesIJNoChosen)';
 taskCounter=taskCounter+1;
 end
 end

 Then, we would use trainXCell and trainYCell as inputs for X and Y in the algorithm.