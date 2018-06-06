% cbenc - takes the LBP data and converts it to 5 x 5 blocks.Returns the 
% Chunked bit feature encoding binary stream of 1920 bits in 8 x 240 matrix.
%
% Usage: 
% [chunk] = cbenc(lbp);
%
% Arguments:
%	lbp       - LBP data
%
% Output:
%   chunk     - the 8 x 240 matrix of binary encoded data
function [chunk] = cbenc(lbp)
    gmean=mean2(lbp);
    gstd=std2(lbp);
    meant=conv2(lbp,ones(5)/25,'same');
    stdt=stdfilt(lbp,ones(5,5));
    %chunk=zeros(8,60);
    chunk=zeros(8,240);
    k=0;
    for i=1:5:size(lbp,1)
        for j=1:5:size(lbp,2)
            k=k+1;
            lmean(k)=meant(i+2,j+2);
            lstd(k)=stdt(i+2,j+2);
        end
    end
%     for k=1:479
%         b1=lmean(k)>gmean;
%         b2=lstd(k)>gstd;
%         b3=lmean(k)>lmean(k+1);
%         b4=lstd(k)>lstd(k+1);
%         chunk(k)=bitshift(uint8(b1),3)+bitshift(uint8(b2),2)+bitshift(uint8(b3),1)+bitshift(uint8(b4),0);
%     end
    k=0;
    for l=1:4:1916
        k=k+1;
        chunk(l)=lmean(k)>gmean;
        chunk(l+1)=lstd(k)>gstd;
        chunk(l+2)=lmean(k)>lmean(k+1);
        chunk(l+3)=lstd(k)>lstd(k+1);
    end
    chunk=reshape(chunk,8,[]);
    