function Y = region_growing(I,xseed,yseed,hole,eps)
[m,n] = size(I);
mask = zeros(m,n);
mask(xseed,yseed) = 1;
mask = uint8(mask);

change = 1;
while change > 0
    change = 0;
    for x = 2:m-1
        for y = 2:n-1
            if Conditions(I,mask,x,y,eps) == 1
                mask(x,y) = 1;
                change = change + 1;
            end
        end
    end
end

% change = 1;
% while change > 0
%     change = 0;
%     for x = 3:m-3
%         for y = 3:n-2
%             if sum(sum(mask(x-2:x+2,y-2:y+2))) > 12 && mask(x,y) == 0
%                 mask(x,y) = 1;
%                 change = change + 1;
%             end
%         end
%     end
% end

mask = 1-mask;
mask = bwareaopen(mask, hole);
mask = 1-mask;

% subplot(1,3,1)
% imshow(I)
% title('Goc');
% 
% subplot(1,3,2)
% imshow(logical(mask))
% title('Mask');
% 
% subplot(1,3,3)
% imshow(I.*uint8(mask))
% title('Ket Qua');

Y = I.*uint8(mask);

function f = Conditions(I,mask,x,y,eps)
f = 0;
neighbors = I(x-1:x+1,y-1:y+1).*uint8(mask(x-1:x+1,y-1:y+1));
if sum(sum(neighbors)) > 0 && mask(x,y) == 0
    Mean = sum(sum(I.*mask))/sum(sum(mask));
    if I(x,y) < Mean + eps && I(x,y) > Mean - eps
        f = 1;
    end
end