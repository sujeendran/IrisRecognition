% getHD - returns the Hamming Distance between two iris chunked bit
% encodings.
% Usage: 
% [hd] = getHD(cbe1,cbe2);
% Arguments:
%	img1       - first template
%   img2       - second template
% Output:
%   hd              - the Hamming distance as a ratio

function hd = getHD(img1,img2,img1name,img2name)
dir='C:\Users\suchi\Documents\MATLAB\Suji IRIS Detection\Data\IrisCodes\';
fname1=[dir,img1name,'_cbe.mat'];
[stat]=fileattrib(fname1);
if (stat==1)
    img1=load(fname1);
    template1=img1.iriscbe;
else
    [template1,irislbp,irisnormal,out] = sujimain(img1,30,50);
    iriscbe=template1;
    save(fname1,'iriscbe');
    imwrite(uint8(irislbp),[dir,img1name,'_lbp.jpg']);
    imwrite(irisnormal,[dir,img1name,'_rpolar.jpg']);
    imwrite(out,[dir,img1name,'_segmented.jpg']);
end

fname2=[dir,img2name,'_cbe.mat'];
[stat]=fileattrib(fname2);
if (stat==1)
    img2=load(fname2);
    template2=img2.iriscbe;
else
    [template2,irislbp,irisnormal,out] = sujimain(img2,30,50);
    iriscbe=template2;
    save(fname2,'iriscbe');
    imwrite(uint8(irislbp),[dir,img2name,'_lbp.jpg']);
    imwrite(irisnormal,[dir,img2name,'_rpolar.jpg']);
    imwrite(out,[dir,img2name,'_segmented.jpg']);
end

%img2=histeq(img2,imhist(img1));

template1 = logical(template1);

template2 = logical(template2);

scales= 2;

hd = NaN;

% shift template left and right, use the lowest Hamming distance
for shifts=-8:8
    
    template1s = shiftbits(template1, shifts,scales);
    
    totalbits = (size(template1s,1)*size(template1s,2));
    
    C = xor(template1s,template2);
    
    bitsdiff = sum(sum(C==1));
    
    if totalbits == 0
        
        hd = NaN;
        
    else
        
        hd1 = bitsdiff / totalbits;
        
        
        if  hd1 < hd || isnan(hd)
            
            hd = hd1;
            
        end
        
        
    end
    
end