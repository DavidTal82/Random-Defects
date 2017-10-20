% modify the discontinuous ID and make it continuous
% Nan Hu, 2016/03/15


% import nodes and elements
nodes = load('nodes.txt');
elements = load('elements.txt');

% extract false ID
falseID = nodes(:,1);

% define new elements
newElem = zeros(size(elements,1),size(elements,2));


% update column by column
for i = 2:size(elements,2)    % the 1st column is elem ID
    
    [tf, loc] = ismember(elements(:,i),falseID);
    
    newElem(:,i) = loc;
    
end

% finish create elem
newElem(:,1) = elements(:,1);

% finish create nodes
nodes(:,1) = 1:1:size(nodes,1);

% output
dlmwrite('nodes_new.txt',nodes,'delimiter',',','precision',9);
dlmwrite('elems_new.txt',newElem,'delimiter',',','precision',9);
