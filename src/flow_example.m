% Frames is sequence of frames, N-by-M-by-T
frame_dir = '../weizmann_part/frames/jump1';
Frames = [];
for f_i=1:10
  Frames(:,:,f_i) = rgb2gray(imread(sprintf('%s/%08d.jpg',frame_dir,f_i)));
end
[VX,VY]=lk3(Frames);
% Visualize (unblurred) flow.
if 1
  im_i=2; % Note, no flow for first and last images.
  figure(1);
  imshow(Frames(:,:,im_i))
  hold on;
  quiver(-VX(:,:,im_i-1),-VY(:,:,im_i-1),0);
  hold off
end
