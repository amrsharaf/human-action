function [VX,VY] = lk3(M3);
% lk3.m does differential (brighness constancy) estimate of optical flow at all points.
% Points which are not corner-ish enough (low eigenvalue ratio) are not given any flow.
%
% M3 is N-M-T matrix, N-by-M frames for T time steps
% VX and VY are N-M-(T-2) are horizontal and vertical flow, note no flow for 1st and last frames


% these 3-tap filters are decribed in the paper by E. Simoncelli
prefilt = [0.223755 0.552490 0.223755];
derivfilt = [-0.453014 0 0.453014];

% alternatively you can try to use derivatives of gaussians for 
% computing the image derivatives here are some examples of
% of them:
% gaussderiv = [0.0047 0.4905 0 -0.4905 -0.0047 ];
% gaussderiv = [0.5000  0   -0.5000];


% serve as weighted sum weighting the middle pixel most
% you can achieve integration (sumation over a window) by 
% convolution with a weight filter
%blur	= [1 6 15 20 15 6 1];
% blur	= [1 1 1 1 1 1 1];
%blur	= blur / sum(blur);

% must match the filter size 

[dimy,dimx,nframes]=size(M3);
wf	= 1; 


% view motion sequence
if(0) 
  clear Mov;
  for i =1 : nframes
    %imshow( seq(i).im,256 );
    imagesc( M3(:,:,i));
    colormap('gray');
    Mov(:,i) = getframe;
  end
  movie(Mov);
end

for fr = 1+wf : nframes-wf,

  %%% SPATIAL AND TEMPORAL DERIVATIVE
  f	= zeros(dimy,dimx);
  
  % prefilter in the temporal diection
  for i = fr - wf : fr + wf
    f = f + prefilt(i-fr+2)*M3(:,:,i);
  end
  
  % compute derivatives in x and y, prefilter in the other dimension
  fx	= conv2( conv2( f, prefilt', 'same' ), derivfilt, 'same' );
  fy	= conv2( conv2( f, prefilt, 'same' ), derivfilt', 'same' );

  ft	= zeros(dimy,dimx);
  % compute derivative in time 
  for i = fr - wf : fr + wf
    ft = ft + derivfilt(i-fr+2)*M3(:,:,i);
  end

  % and prefilter in the other directions 
  ft	= conv2( conv2( ft, prefilt', 'same' ), prefilt, 'same' );


  % COMPUTE FLOW (at each s-th pixel)
  s	= 1;
  w       = 1;

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Here goes your code for flow computation the resulting flow is 
  % stored in arrays Vx and Vy
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  Vx = zeros([dimy dimx]);
  Vy = zeros([dimy dimx]);
  Vcor = zeros([dimy dimx]);
  %blur2 = blur'*blur;
  %blur3 = blur2(:);
  %b2 = blur3*blur3';

  for x=1+w:dimx-w,
    for y=1+w:dimy-w,
      ax = fx(y-w:y+w,x-w:x+w);
      ay = fy(y-w:y+w,x-w:x+w);
      bb = -ft(y-w:y+w,x-w:x+w);
      b = bb(:);
      a = [ax(:), ay(:)];
      aa = a'*a;
      Vcor(y,x) = min(eig(aa));
      if (min(eig(aa)) > 0.001),
	v = pinv(aa)*a'*b;
	Vx(y,x) = v(1);
	Vy(y,x) = v(2);
      end;
    end;
  end;


  %% Debug, visualization of this frame.
  if 0,
    figure(3);
    imagesc(f);
    hold on;
    quiver(-Vx,-Vy,0);
    hold off;
    drawnow;
    figure(4);
    imagesc(Vx.*(Vx>0),[0 4]);
    drawnow;
    pause;
  end;

  VX(:,:,fr-1) = Vx;
  VY(:,:,fr-1) = Vy;
  %FX(:,:,fr) = fx;
  %FY(:,:,fr) = fy;
  %FT(:,:,fr) = ft;
end;

