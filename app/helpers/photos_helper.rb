module PhotosHelper
end


=begin
require 'rubygems'
require 'exifr'

obj = EXIFR::JPEG.new('geo.jpg')
if obj.exif?
  puts "--- EXIF information ---".center(50)
  hash??= obj.exif.to_hash
  hash.each_pair do |k, v|
    puts "-- #{k.to_s.rjust(20)} -> #{v}"
  end
end

	
end
             --- EXIF information ---
--     gps_latitude_ref -> N
--    pixel_x_dimension -> 600
--   date_time_original -> Sat Nov 21 09:24:08 +0800 2009
--         y_resolution -> 72
--      resolution_unit -> 2
-- gps_img_direction_ref -> T
--     exposure_program -> 2
--   ycb_cr_positioning -> 1
--            sharpness -> 1
--    pixel_y_dimension -> 800
--                flash -> 32
--  date_time_digitized -> Sat Nov 21 09:24:08 +0800 2009
--                 make -> Apple
--    gps_img_direction -> 102933/295
--        gps_longitude -> 104809/200
--         focal_length -> 77/20
--                model -> iPhone 3GS
--             software -> 3.1.2
--       gps_time_stamp -> 924417/100
--    iso_speed_ratings -> 76
--    gps_longitude_ref -> W
--            date_time -> Sat Nov 21 09:24:08 +0800 2009
--        exposure_mode -> 0
--  shutter_speed_value -> 5855/1277
--        exposure_time -> 1/24
--         gps_latitude -> 391019/200
--       sensing_method -> 2
--          color_space -> 1
--        metering_mode -> 1
--         x_resolution -> 72
--        white_balance -> 0
--       aperture_value -> 4281/1441
--             f_number -> 14/5

未加工前的坐标信息是以时/分/秒构成的, 类似这样:
:gps_latitude=>[Rational(39, 1), Rational(1019, 20), Rational(0, 1)]


2. 加工坐标信息
lat = obj.exif[0].gps_latitude[0].to_f + (obj.exif[0].gps_latitude[1].to_f / 60) + (obj.exif[0].gps_latitude[2].to_f / 3600)
lat = lat * -1 if obj.exif[0].gps_latitude_ref == 'S'    # (N is +, S is -)
long = obj.exif[0].gps_longitude[0].to_f + (obj.exif[0].gps_longitude[1].to_f / 60) + (obj.exif[0].gps_longitude[2].to_f / 3600)
long = long * -1 if obj.exif[0].gps_longitude_ref == 'W' # (W is -, E is +)
加工后的坐标信息类似这样:
39.8491666666667 #  lat
-104.674166666667 # long


坐标转换方法
#　Example. Assume a latitude of 45° 53' 36" (45 degrees, 53 minutes and 36 seconds). In degrees, the latitude will be:
latitude = 45 + (53 / 60) + (36 / 3600) = 45.89
#　General Formulation:
latitude (degrees) = degrees + (minutes / 60) + (seconds / 3600)
=end
