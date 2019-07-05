% 1. Set workspace and launch the Imaris software
cd('C:\xu\Imaris x64 7.4.2\Imaris x64 7.4.2\XT\matlab')
javaaddpath ImarisLib.jar;
! ../../Imaris.exe id101 &
vImarisLib = ImarisLib;
vObjectId = 101;
for vIndex = 1:100 % do several attempts waiting for Imaris to be registered 
    vImaris = vImarisLib.GetApplication(vObjectId); 
    if ~isempty(vImaris) 
        break 
    end
    pause(0.1)
end
vImaris.SetVisible(true);
%disp(vImaris.GetVisible);

% 2. Open image and start processing
vImaris.FileOpen('C:\xu\image TEST\image TEST\ISVZ1 brdu.tif', '')

% 2.1 add new spots
vImage = vImaris.GetDataSet;
vMin = [vImage.GetExtendMinX, vImage.GetExtendMinY, vImage.GetExtendMinZ];
vMax = [vImage.GetExtendMaxX, vImage.GetExtendMaxY, vImage.GetExtendMaxZ];
vCenter = (vMax + vMin) / 2;
vSpots = vImaris.GetFactory.CreateSpots;
vSpots.SetName('newspot');
vSpots.Set(vCenter, 0, 2);
vScene = vImaris.GetSurpassScene;
vScene.AddChild(vSpots, -1);



ss = vImaris.GetImageProcessing
nn = ss.DetectSpots(vImage, 0, 3527.78, 1, 1, 3900, 5)

vImaris.GetImageProcessing.DetectSpotsWithRegions(vImage, 0, 2, 1, 0.5, 1, 0, 30, 1, 1)

vImaris.GetImageProcessing.TrackSpotsConnectedComponents(nn, 'test1')

st = vSpots.GetStatistics
vv = st.mValues('Total Number of Spots')
round(vv(11))
% vImage.SetParameter('Image', 'NumericalAperture', '1.4')

% 2.2 add new filaments
%{
vFilaments = vImaris.GetFactory.CreateFilaments;
vImaris.GetSurpassScene.AddChild(vFilamnts)
%}

% 2.3 add new surfaces
%{
vSurfaces = vImaris.GetFactory.CreateSurfaces;
vImaris.GetSurpassScene.AddChild(vSurfaces)
%}

% 2.4 add new cells
%{
vCells= vImaris.GetFactory.CreateCells;
vImaris.GetSurpassScene.AddChild(vCells)
%}

% 2.5 volum
volume1 = vImaris.GetFactory.ToVolume(vImaris.GetSurpassSelection);
st = volume1.GetStatistics

% 2.6 slice
vImage.GetSizeZ;
vSliceIndex = floor(vImage.GetSizeZ /2);
vNumberOfChannels = vImage.GetSizeC;
vNumberOfSlices = vImage.GetSizeZ;
for vChannel = 0:vNumberOfChannels-1
    vData = vImage.GetDataSliceFloats(vSliceIndex, vChannel, 0);
    size(vData)
    vMaximum = max(vData(:));
    vInvertedData = vMaximum - vData;
    vImage.SetDataSliceFloats(vInvertedData, vSliceIndex, vChannel, 0);
end

% 3. Export the statistics file

