function Unit_Cell_Visualization1(volume_3D)

lin_ind = find(volume_3D);
[x_el,y_el,z_el] = ind2sub(size(volume_3D),lin_ind);

figure
plot3(x_el,y_el,z_el,'.','MarkerSize',1);
grid on,axis equal;
xlabel('x'),ylabel('y'),zlabel('z');

end

