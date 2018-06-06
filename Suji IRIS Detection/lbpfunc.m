% lbpfunc - generates local binary pattern for given image and radius
% Usage: 
% [O] = lbpfunc(I,R);
% Arguments:
%	I       - Image
%   R       - Radius
% Output:
%   O              - LBP image
function [O]=lbpfunc(I, R)

if size(I, 3) == 3
    I = rgb2gray(I);
end
I = medfilt2(I);
O = zeros(size(I));
rows=size(I,1);
cols=size(I,2);

%For LBP 8,1
if R == 1
    for row = 2 : rows - 1   
        for col = 2 : cols - 1
            centerPixel = I(row, col);
            pixel7=I(row-1, col-1) > centerPixel;  
            pixel6=I(row-1, col) > centerPixel;   
            pixel5=I(row-1, col+1) > centerPixel;  
            pixel4=I(row, col+1) > centerPixel;     
            pixel3=I(row+1, col+1) > centerPixel;    
            pixel2=I(row+1, col) > centerPixel;      
            pixel1=I(row+1, col-1) > centerPixel;     
            pixel0=I(row, col-1) > centerPixel;       
            O(row, col) = uint8(pixel7 * 2^7 + pixel6 * 2^6 + pixel5 * 2^5 + pixel4 * 2^4 + pixel3 * 2^3 + pixel2 * 2^2 + pixel1 * 2 + pixel0);
        end  
    end 
end

%For LBP 8,4
if R==4
    I = padarray(I,[4,4],0,'both');
    for row = 1 : rows   
        for col = 1 : cols    
            centerPixel = I(row+4, col+4);
            pixel7=I(row, col) > centerPixel;   
            pixel6=I(row, col+4) > centerPixel;      
            pixel5=I(row, col+8) > centerPixel;    
            pixel4=I(row+4, col+8) > centerPixel;  
            pixel3=I(row+8, col+8) > centerPixel;   
            pixel2=I(row+8, col+4) > centerPixel;       
            pixel1=I(row+8, col) > centerPixel;     
            pixel0=I(row+4, col) > centerPixel;       
            O(row, col) = uint8(pixel7 * 2^7 + pixel6 * 2^6 + pixel5 * 2^5 + pixel4 * 2^4 + pixel3 * 2^3 + pixel2 * 2^2 + pixel1 * 2 + pixel0);
        end  
    end 
end
