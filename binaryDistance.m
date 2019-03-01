%Load the image and convert to grayscale for easier manipulation 
imgLoad = imread('binary.jpeg'); 
img = rgb2gray(imgLoad); 

%get the dimensions of the image 
[m,n] = size(img); 

%next get the number of k values the user wants 
numK = input('please type in the number of k values you want'); 

%make an array to store the k coordinate values 
kC = zeros(2, numK); 

%Select the number of points that the user has requested 
for x = 1 : numK
    figure; imshow(img);
    [x1, y1] = getpts;
    kC(1,x) = round(x1);
    kC(2,x) = round(y1);
end

%Assign each pixel to a k point
%initallize assignment map 
segMap = zeros(50); 

%checkmap for debugging purposes 
checkmap = zeros(50); 

%Then for each 0 pixel, assign it to the closest K point
for row = 1 : m
    for col = 1 : n
        %Check if the point is a 0 pixel
        if img(row, col) == 0
            %if true then we find the distance it has away from each k
            %initalize an array to store distances
            distanceArray = zeros(1,numK); 
            for i = 1 : numK 
                distanceArray(1,i) = round(sqrt((row - kC(2,i))^2 + (col - kC(1,i))^2));
            end 
            %find the smallest distance
            tempDist = distanceArray(1,1); 
            tempSeg = 1; 
            for i = 2 : numK
                if distanceArray(1,i) < tempDist
                    tempDist = distanceArray(1,i); 
                    tempSeg = i; 
                end
            end
            %once the smallest point is found, assign that point to that k
            %value on the segmap; 
            segMap(row, col) = tempSeg;
            checkmap(row, col) = tempSeg;
        end
    end
end

%Once the inital regions are identified, we will continuously calculate the
%new k average values until k value changes stop 

change = true;

while change 
    %while the change function is true then continue to evaluate a new k
    %value and remap the points again 
    %evaluate new k value 
    tempkC = kC; 
    for i = 1 : numK
        numK
        tempX = 0; 
        tempY = 0;
        noPoints = 0; 
        for row = 1 : m
            for col = 1 : n 
                if segMap(row, col) == i
                    tempX = tempX + col;
                    tempY = tempY + row;
                    noPoints = noPoints + 1;  
                end
            end
        end
        kC(1,i) = round(tempX / noPoints) 
        kC(2,i) = round(tempY / noPoints) 
    end 
    if tempkC == kC 
        %if the old values of the kC is the same as the newly caluclated kC
        %then no changes has occured hence we exit the loop 
        change = false; 
    else 
        %If not then we remap all the pixels to the theend new kC values
        %Since we are remapping, we will clear the segMap 
        segMap = zeros(m);
        
        for row = 1 : m
            for col = 1 : n 
                %for every pixel that is 0 i.e. black
                if img(row, col) == 0 
                    %we caluclate its distance from all the new kValues  
                    tempLowest = 0;
                    tempChosenSeg = 1; 
                    for i = 1 : numK 
                        if i == 1
                            %populate the first value into the temp for
                            %comparision 
                            tempLowest = round(sqrt((m - kC(2,i))^2 + (n - kC(1,i))^2));
                        else 
                            tempD2 = round(sqrt((m-kC(2,i))^2 + (n - kC(1,i))^2));
                            if tempLowest > tempD2
                                tempLowest = tempD2; 
                                tempChosenSeg = i;
                            end 
                        end
                    end
                    %Chosen region of segment is found, then assign that
                    %pixel to that region
                    segMap(row, col) = tempChosenSeg; 
                end
            end
        end
    end
    
    
end 
%for visual purposes, show the regions in different images  
subplot(numK+1,1,1);
imshow(img); 
for kValue = 1 : numK
    tempDist = zeros(50); 
    for row = 1 : m
        for col = 1 : n
            if segMap(row, col) == kValue
                tempDist(row, col) = 255;
            end
        end
    end
    subplot(numK+1,1, kValue+1);
    imshow(tempDist);
end

                


