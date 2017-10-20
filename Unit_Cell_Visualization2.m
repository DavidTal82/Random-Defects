function Unit_Cell_Visualization2(volume_3D)

[x_dim,y_dim,z_dim] = size(volume_3D);
[x,y,z] = ndgrid(1:x_dim,1:y_dim,1:z_dim);
    

figure
p = patch(isosurface(x,y,z,volume_3D,0.5));
set(p, 'FaceColor', 'red', 'EdgeColor', 'none');
view(3)
camlight
lighting gouraud
grid on,axis([1 x_dim 1 y_dim 1 z_dim]);
axis equal
xlabel('X'),ylabel('Y'),zlabel('Z')

end

