clear 
close

temp1 = csvread('DefectedNodes.txt');
temp2 = csvread('DefectedElements.txt');

Nodes = zeros(length(temp1),3);
Elements = temp2(:,2:end);
index_node = (1:length(temp1))';
difind = find(temp1(:,1)~=index_node);

for i=1:length(difind);
    
    no = temp1(difind(i),1);
    Elements(Elements==no) = difind(i);
    i
%     if i==temp1(i,1)
%         Nodes(i,:) = (temp1(i,2:end));
%     else
%         old = temp1(i,1);
%         dif = (temp1(i,1)-i);
%         
%         temp(i:end,1) = temp1(i:end,1) - dif;
%         ind = Elements >= old;
%         Elements(ind) = Elements(ind)-dif;
%     end       
    
end