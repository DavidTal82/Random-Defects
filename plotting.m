function plotting(volume)

lin_ind = find(volume);
[x,y,z] = ind2sub(size(volume),lin_ind);

figure
plot3(x,y,z,'.','MarkerSize',1);
grid on,axis equal;
xlabel('x'),ylabel('y'),zlabel('z');

end

