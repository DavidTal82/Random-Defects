function [Geometry]=get_Image_Data(I,min_vol)

if nargin < 2
    min_vol = 3;
end

[y_dim,x_dim] = size(I);

x=(1:x_dim)';
y=(1:y_dim)';

[xx,yy] = meshgrid(x,y);


%extracting data from the binary image
DATA = regionprops(I,...
    'Centroid','MajorAxisLength','MinorAxisLength','Orientation','Area');
DATA = sortStruct(DATA,'Area', -1);

%turning the data in to a matrix instead of a structure
temp=[DATA.Centroid];             %center of mass of the region
geo1=[temp(1:2:end)',temp(2:2:end)'];
geo3=[DATA.MajorAxisLength]';     %length (pixels) of the major axis of the ellipse
geo4=[DATA.MinorAxisLength]';     %length (pixels) of the minor axis of the ellipse
geo5=[DATA.Orientation]';         %the angle (deg, -90 to 90) between x and major axis
geo6=geo4./geo3;                  %minor-major axis ratio
geo7=[DATA.Area]';                %actual number of pixels in the region

geo5( geo5 < 0 ) = geo5( geo5 < 0 ) + 180;

% indexes=find(geo3 > 1);
% geo=[geo1(indexes,:),geo3(indexes,:),geo4(indexes,:),geo5(indexes,:),geo6(indexes,:),geo7(indexes,:)];
Geometry = [geo1,geo3,geo4,geo5,geo6,geo7];
Geometry((Geometry(:,7) < min_vol),:) = [];

[R,~] = size(Geometry);

an_a=degtorad(Geometry(:,5));
an_b= pi - an_a;

the=linspace(0,2*pi,300);

for r=1:R
    
    Ia = false(size(I));
    Ib = false(size(I));
    
    xpos=Geometry(r,1);
    ypos=Geometry(r,2);
    radm=Geometry(r,3)/2;
    radn=Geometry(r,4)/2;
    
    co_a=cos(an_a(r));
    si_a=sin(an_a(r));
    
    co_b=cos(an_b(r));
    si_b=sin(an_b(r));
    
    x_a = radm*cos(the)*co_a-si_a*radn*sin(the)+xpos;
    y_a = radm*cos(the)*si_a+co_a*radn*sin(the)+ypos;
    
    x_b = radm*cos(the)*co_b-si_b*radn*sin(the)+xpos;
    y_b = radm*cos(the)*si_b+co_b*radn*sin(the)+ypos;
    
    in_a = inpolygon(xx(:),yy(:),x_a,y_a);
    in_b = inpolygon(xx(:),yy(:),x_b,y_b);
    
    Ia(in_a) = 1;
    Ib(in_b) = 1;
    
    Area_ratio_a = sum(sum(Ia.*I))/Geometry(r,7);
    Area_ratio_b = sum(sum(Ib.*I))/Geometry(r,7);
    
    if Area_ratio_a > Area_ratio_b
        Geometry(r,5) = degtorad(Geometry(r,5));
    else
        Geometry(r,5) = pi - degtorad(Geometry(r,5));
    end
    
    
end

end
