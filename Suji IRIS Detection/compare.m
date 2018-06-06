%Function to perform iris comparison on database mentioned
function compare()
logfile=fopen('C:\Users\suchi\Documents\MATLAB\Suji IRIS Detection\Data\Compare Log 34.txt','a+');
fprintf(logfile,'---------------------------------------------------------------------------\r\n');
fprintf(logfile,'%6s %12s %18s %24s\r\n','Img1','Img2','HD','Status');

%Below code compares every image files from a folder

srcFiles = dir('D:\MSc in AI\Human Recog\UBIRIS_200_150_R\randcol\*.jpg');  % the folder in which ur images exists
for i = 1 : length(srcFiles)-1
    img1 = imread((strcat('D:\MSc in AI\Human Recog\UBIRIS_200_150_R\randcol\',srcFiles(i).name)));
    for j=i+1 : length(srcFiles)
        img2 = imread((strcat('D:\MSc in AI\Human Recog\UBIRIS_200_150_R\randcol\',srcFiles(j).name)));
          hd=getHD(img1,img2,srcFiles(i).name,srcFiles(j).name);
          if(hd<0.335)
            status="Match";
            else
            status="No Match";
          end
          fprintf(logfile,'%6s %12s %15.6f %18s\r\n', srcFiles(i).name, srcFiles(j).name, hd, status);
    end
end

% Below code compares every image file from a folder to every image file in
% another folder

% fold1 = dir('D:\MSc in AI\Human Recog\UBIRIS_200_150_R\Train2\*.jpg');  % the folder in which ur images exists
% fold2 = dir('D:\MSc in AI\Human Recog\UBIRIS_200_150_R\Test\*.jpg');
% for i = 1 : length(fold1)
%     img1 = imread(strcat('D:\MSc in AI\Human Recog\UBIRIS_200_150_R\Train2\',fold1(i).name));
%     for j=1 : length(fold2)
%         img2 = imread(strcat('D:\MSc in AI\Human Recog\UBIRIS_200_150_R\Test\',fold2(j).name));
%         hd=getHD(img1,img2,fold1(i).name,fold2(j).name);
%         if(hd<0.331001)
%             status="Match";
%         else
%             status="No Match";
%         end
%         fprintf(logfile,'%6s %12s %15.6f %18s\r\n', fold1(i).name, fold2(j).name, hd, status);
%     end
% end

fclose(logfile);