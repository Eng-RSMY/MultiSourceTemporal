
function [np,gam,hm,tm,hv,tv] = outvario(nlg,in7,ndir,nvarg,in1,in2,in3,in4,in5,in6,ivtype)

% Organization of variograms output variables
% Input: results of VARIO*.m
% output: np, gam, hm, tm, hv and tv pseudo-3D matrices
% 	- first row is the variogram number corresponding to eah colomn
%	- first colomn is the distance (equivalent to 'dis' for vario2di and vario3di) or
%         the lag number (for vario2dr and vario3dr)	  
%	- the third dimension is the equivalent for each direction

% check input-output

np  = ivtype(:)';
gam = ivtype(:)';
hm  = ivtype(:)';
tm  = ivtype(:)';
hv  = ivtype(:)';
tv  = ivtype(:)';

for id = 1:ndir
     	for iv=1:nvarg
		for il = 1:nlg
			iloc = (id-1)*nvarg*nlg+(iv-1)*nlg+il;
			np(il+1+(id-1)*nlg,iv)  = in1(iloc);
			gam(il+1+(id-1)*nlg,iv) = in2(iloc);
			hm(il+1+(id-1)*nlg,iv)  = in3(iloc);
			tm(il+1+(id-1)*nlg,iv)  = in4(iloc);
			hv(il+1+(id-1)*nlg,iv)  = in5(iloc);
			tv(il+1+(id-1)*nlg,iv)  = in6(iloc);
			if (length(in7) == 1)
				dis(il+(id-1)*nlg,iv) = il;
			else
				dis(il+(id-1)*nlg,iv) = in7(iloc);
			end
		end
	end
end

np  = [ [0;dis(:,1)]  np ];
gam = [ [0;dis(:,1)]  gam];
hm  = [ [0;dis(:,1)]  hm ];
tm  = [ [0;dis(:,1)]  tm ];
hv  = [ [0;dis(:,1)]  hv ];
tv  = [ [0;dis(:,1)]  tv ];