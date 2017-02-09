clear
dirpath='/Users/mathildebateson/Documents/MVA/Reminiz/Data/input_training';
currentpath=pwd;

cd(dirpath)
listing_forward=dir('t*');
listing_backward=dir('B*');

for i=1:length(listing_forward)
    cd([listing_forward(i).folder '/' listing_forward(i).name]);
    tmp=dir('im*.jpeg');
    listing.forward{i,1}.dirpath=tmp(1).folder;
    listing.forward{i,1}.im_number=length(tmp);
    for j=1:length(tmp)
        listing.forward{i,1}.im_names{j,1}=tmp(j).name;
    end
end
for i=1:length(listing_backward)
    cd([listing_backward(i).folder '/' listing_backward(i).name]);
    tmp=dir('im*.jpeg');
    listing.backward{i,1}.dirpath=tmp(1).folder;
    listing.backward{i,1}.im_number=length(tmp);
    for j=1:length(tmp)
        listing.backward{i,1}.im_names{j,1}=tmp(j).name;
    end
end


cd(currentpath)