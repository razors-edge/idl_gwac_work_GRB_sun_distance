pro angular_distance_SWIFTGRB_sun
close,/all
inputfile=filepath('swiftgrb_table_1364359868.dat',$
root_dir='E:\WORK\GWAC_work\angular_distance_swiftgrb_sun\')
outputfile=filepath('angular_distance_SWIFTGRB_sun.dat',$
root_dir='E:\WORK\GWAC_work\angular_distance_swiftgrb_sun\')
outputfile1=filepath('angular_distance_SWIFTGRB_sun',$
root_dir='E:\WORK\GWAC_work\angular_distance_swiftgrb_sun\')
openw,80,outputfile,width=2000


if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec=linenum_multi_col(inputfile,str)
close,60
record={ID:'',trig_time:' ',trig_num:0L,radeg:0.0d,decdeg:0.0d,duration:0.0d,radeg_sun:0.0d,decdeg_sun:0.0d,distance_d:0.0d}
data=replicate(record,maxrec)
str=''

entry_device=!d.name
!p.multi=[0,1,2]
set_plot,'ps'
device,file=outputfile1 + '.ps',xsize=8,ysize=8,/inches,xoffset=0.1,yoffset=0.1,/Portrait
device,/color
loadct_plot
!p.position=0


openr,50,inputfile
point_lun,50,0
for i=0L, maxrec-1 do begin
readf,50,str
word = strsplit(str,/EXTRACT)
data[i].ID = word[0]
data[i].trig_time = word[1]
data[i].trig_num = word[2]
data[i].radeg = word[3]
data[i].decdeg = word[4]
data[i].duration = word[5]
year = '20'+STRMID(data[i].ID,0,2) 
month = STRMID(data[i].ID,2,2) 
day = STRMID(data[i].ID,4,2)

jdcnv, year,month,day,0, jd
sunpos, jd,radeg_sun,decdeg_sun

data[i].radeg_sun = radeg_sun
data[i].decdeg_sun = decdeg_sun
;angular_distance,data[i].radeg,data[i].decdeg,data[i].radeg_sun,data[i].decdeg_sun,data[i].distance_d
angular_distance,data[i].radeg,data[i].decdeg,data[i].radeg_sun,data[i].decdeg_sun,distance_d
data[i].distance_d = distance_d
print,"GRB"+data[i].ID,adstring(data[i].radeg,data[i].decdeg,2),"  sun ",adstring(data[i].radeg_sun,data[i].decdeg_sun,2),"  distance:",data[i].distance_d
printf,80,"GRB"+data[i].ID,adstring(data[i].radeg,data[i].decdeg,2),"  sun ",adstring(data[i].radeg_sun,data[i].decdeg_sun,2),"  distance:",data[i].distance_d

endfor

bin=( FindGen(18) * 10 )
n=make_array(18, /INTEGER )
for j=0L, 16 do begin
n[j]=0L
index=WHERE(((data.distance_d gt bin[j]) and (data.distance_d le bin[j+1])), count )
n[j] = count
endfor

;print,n

cthick=2
csize=1
plot,bin,n,$
xrange=[0,180],yrange=[0,100],$
xstyle=1,$
ystyle=1,$
xthick=3,ythick=3,$
xtitle='Angular distance between Swift GRB and Sun (degree)',$
XCHARSIZE=1.5,$
ytitle='Number',YCHARSIZE=1.5, $
psym=8,charthick=3,$
color=0,position=[0.15,0.15,0.9,0.9],/nodata
FOR z = 0, 17 DO begin
EX_BOX, bin[z], !Y.CRANGE[0], bin[z]+8,$ 
n[z],1
xyouts,bin[z]-12,n[z]+10,n[z],charsize=csize,color=0,charthick=cthick
endfor


close,50
close,80
close,/all
device,/close_file
print,'Done'
end