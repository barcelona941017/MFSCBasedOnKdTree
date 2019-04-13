function ff = medfilt3_diy(image,filt_size)
Ir = image(:,:,1);
Ig = image(:,:,2);
Ib = image(:,:,3);
Ir_filter = medfilt2(Ir,filt_size);
Ig_filter = medfilt2(Ig,filt_size);
Ib_filter = medfilt2(Ib,filt_size);
ff = cat(3,Ir_filter,Ig_filter,Ib_filter);