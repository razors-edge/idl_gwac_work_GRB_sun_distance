pro FermiGRB_format_convert
close,/all
inputfile=filepath('fermigrb_table_1364439272.txt',$
root_dir='E:\WORK\GWAC_work\angular_distance_swiftgrb_sun\')
outputfile=filepath('fermigrb_table_1364439272.dat',$
root_dir='E:\WORK\GWAC_work\angular_distance_swiftgrb_sun\')
openw,80,outputfile,width=2000


if(n_elements(inputfile) eq 0) then $
message,'Argument FILE is underfined'
str=''
maxrec=linenum_multi_col(inputfile,str)
close,60
record={ID:'',grbname:' ',radeg:0.0d,decdeg:0.0d,trig_yy:0,trig_mm:0,trig_dd:0,trig_UT:0.0d,reliability:' '}
data=replicate(record,maxrec)
str=''

openr,50,inputfile
point_lun,50,0
for i=0L, maxrec-1 do begin
readf,50,str
word = strsplit(str,'|', /EXTRACT)
data[i].ID = word[0]
data[i].grbname = word[1]
ra_h=ten(word[2])
data[i].radeg = ra_h * 15.
data[i].decdeg=ten(word[3])

word1 = strsplit(word[4], /EXTRACT)
data[i].trig_yy = STRMID(word1[0],0,4)
data[i].trig_mm = STRMID(word1[0],5,2)
data[i].trig_dd = STRMID(word1[0],8,2)
data[i].trig_UT=ten(word1[1])
data[i].reliability = word[6]
print,data[i]
printf,80,data[i].ID,data[i].grbname,data[i].radeg,data[i].decdeg,$
data[i].trig_yy,data[i].trig_mm,data[i].trig_dd,data[i].trig_UT,data[i].reliability
endfor

close,50
close,80
close,/all
device,/close_file
print,'Done'
end