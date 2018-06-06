%Function to search for the centre coordinates of the iris and pupil along
%with it's radii followed by normalization,lbp and chunked encoding.
%INPUTS:
%I:image to be segmented
%rmin=30; rmax=50;
%rmin ,rmax:the minimum and maximum values of the iris radius
%debug(optional): add an argument 1 to the end to display segmented image
%OUTPUTS:
%iriscbe:chunked encoded binary data stream
%irislbp:lbp
%irisnormal:normalized image
%out:segmented image

function [iriscbe,irislbp,irisnormal,out]=sujimain(I,rmin,rmax,varargin)
imagewithcircles = uint8(I);
I=im2double(I);
I=imcomplement(imfill(imcomplement(I),'holes'));
%imwrite(I,'noreflect.jpg','jpg');
%Removes reflections by using the morphological operation 'imfill'

rows=size(I,1);
cols=size(I,2);
[X,Y]=find(I<0.5);
%tresholding;x & y
s=size(X,1);
%normalisation parameters
radial_res = 39;
angular_res = 150;
for k=1:s %
    if (X(k)>rmin)&&(Y(k)>rmin)&&(X(k)<=(rows-rmin))&&(Y(k)<(cols-rmin))
            A=I((X(k)-1):(X(k)+1),(Y(k)-1):(Y(k)+1));
            M=min(min(A));
            %this checks if it is a local minimum
           if I(X(k),Y(k))~=M
              X(k)=NaN;
              Y(k)=NaN;
           end
    end
end
v=find(isnan(X));
X(v)=[];
Y(v)=[];
%deletes all pixels that are NOT local minima(that have been set to NaN)
index=find((X<=rmin)|(Y<=rmin)|(X>(rows-rmin))|(Y>(cols-rmin)));
X(index)=[];
Y(index)=[];  
%This deletes all pixels that are so close to the border as not possible be the centre coordinates.
N=size(X,1);
%size after deleting unnecessary elements
maxb=zeros(rows,cols);
maxrad=zeros(rows,cols);
%to store max values of blur
for j=1:N
    [b,r,blur]=partiald(I,[X(j),Y(j)],rmin,rmax,'inf',600,'iris');%coarse search
    maxb(X(j),Y(j))=b;
    maxrad(X(j),Y(j))=r;
end
[x,y]=find(maxb==max(max(maxb)));
ci=search(I,rmin,rmax,x,y,'iris');%finds the maximum value of blur by scanning all the centre coordinates
cp=search(I,round(0.1*rmin),round(0.8*rmax),x,y,'pupil');

%Normalization
irisnormal=rsnormal(imagewithcircles, cp(2), cp(1), cp(3), ci(2), ci(1), ci(3)-10,'DebugMode',0,'AngleSamples',angular_res,'RadiusSamples',radial_res);

%LBP
irislbp = lbpfunc(irisnormal,4);

%Chunked Bit Feature Encoding
iriscbe = cbenc(irislbp);

%displaying the segmented image. Only in debug mode
if nargin>3
    figure('name','Iris and Pupil');
    imshow(imagewithcircles); 
    hold on;
    theta=(2*pi)/600;
    angle=theta:theta:2*pi;
    pline_y = cp(3) * cos(angle) + cp(1);
    pline_x = cp(3) * sin(angle) + cp(2);
    plot(pline_x, pline_y, 'w');
    iline_y = ci(3) * cos(angle) + ci(1);
    iline_x = ci(3) * sin(angle) + ci(2);
    plot(iline_x, iline_y, 'w');
    hold off;
end

out=drawcircle(imagewithcircles,[ci(1),ci(2)],ci(3),600);
out=drawcircle(out,[cp(1),cp(2)],cp(3),600);





