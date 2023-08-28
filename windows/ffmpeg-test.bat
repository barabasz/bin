ffmpeg -y -i test.mp4 -vf ^
"[in] split=10 [org][s1][s2][s3][s4][m1][m2][m3][m4][c1];^
 [org] eq=brightness=-1 [org];^
 [s1] crop=iw/2:ih/2:0:0, negate, boxblur=luma_radius=min(h\,w)/100:luma_power=1:chroma_radius=min(cw\,ch)/100:chroma_power=1 [s1];^
 [s2] crop=iw/2:ih/2:iw/2:0, elbg=codebook_length=24:nb_steps=2, curves=preset=vintage [s2];^
 [s3] crop=iw/2:ih/2:0:ih/2, hue=h=90:s=2, curves=preset=increase_contrast [s3];^
 [s4] crop=iw/2:ih/2:iw/2:ih/2, noise=alls=100:allf=t+u, curves=preset=cross_process [s4];^
 [m1] scale=iw/4:ih/4, hue=s=0[m1];^
 [m2] scale=iw/4:ih/4, lutrgb=g=0:b=0 [m2];^
 [m3] scale=iw/4:ih/4, lutrgb=r=0:b=0 [m3];^
 [m4] scale=iw/4:ih/4, lutrgb=r=0:g=0 [m4];^
 [c1] scale=iw/4:ih/4 [c1];^
 [org][s1] overlay=0:0 [out];^
 [out][s2] overlay=W/2:0 [out];^
 [out][s3] overlay=0:H/2 [out];^
 [out][s4] overlay=W/2:H/2 [out];^
 [out][m1] overlay=0:0 [out];^
 [out][m2] overlay=W-W/4:0 [out];^
 [out][m3] overlay=0:H-H/4 [out];^
 [out][m4] overlay=W-W/4:H-H/4 [out];^
 [out][c1] overlay=(W-w)/2:(H-h)/2 [out];^
 [out] fade=in:0:50,fade=out:250:50^
" -af "loudnorm, afade=t=in:ss=0:d=1, afade=t=out:st=5:d=1" -crf 20 out.mp4
