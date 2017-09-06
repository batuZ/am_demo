require 'exifr/jpeg'
require 'exifr/tiff'
# https://github.com/remvee/exifr/blob/master/bin/exifr

class PhotosController < ApplicationController
  before_action :set_photo, only: [:show, :edit, :update, :destroy]

  # GET /photos
  # GET /photos.json
  def index
    @photos = Photo.all
  end

  # GET /photos/1
  # GET /photos/1.json
  def show
  end

  # GET /photos/new
  def new
    @photo = Photo.new
  end

  # GET /photos/1/edit
  def edit
  end

  # POST /photos
  # POST /photos.json
  def create
    @group = Group.find(params[:group_id])
    files = params[:photo][:avatar]
    logger.debug "MyDebug: getFiles #{files.count}"
    for f in files do
      pp = Photo.new 
      pp.name = f.original_filename
      pp.group_id = params[:group_id]
      pp.tagPath = "#{@group.project_id}/#{@group.id}"
      pp.avatar = f
      logger.debug "beforeSAVE: #{pp.name}"
      pp.save

      # obj = nil
      # if pp.avatar.identifier.downcase.include? '.jpg' 
      #   obj = EXIFR::JPEG.new(pp.avatar.current_path)
      # elsif pp.avatar.identifier.downcase.include? '.tif' 
      #   obj = EXIFR::JPEG.new(pp.avatar.current_path)
      # end
      # if obj
      #   @group.camera_model = obj.model         if !@group.camera_model   # => "Canon PowerShot G3"
      #   @group.width =  obj.width               if !@group.width          # => 2272
      #   @group.height = obj.height              if !@group.height         # => 1704
      #   @group.focal_length = obj.focal_length  if !@group.focal_length   # => 100/1
      #   pp.X = obj.gps.latitude  if obj.gps   # => 52.7197888888889
      #   pp.Y = obj.gps.longitude if obj.gps   # => 5.28397777777778
      #   pp.Z = obj.gps.altitude  if obj.gps   # => 444
      #   pp.save

      #   end
    end
 #   @group.save
    # @photo = Photo.new(photo_params)
    # @photo.group_id = params[:group_id]
    # @photo.tagPath = "#{@group.project_id}/#{@group.id}"
    # @photo.name = params[:photo][:avatar].original_filename

    #   if @photo.save
          
    #       #get EXIF
    #       if @photo.avatar.identifier.downcase.include? '.jpg' 
    #         @obj = EXIFR::JPEG.new(@photo.avatar.current_path)
    #       elsif @photo.avatar.identifier.downcase.include? '.tif' 
    #         @obj = EXIFR::JPEG.new(@photo.avatar.current_path)
    #       end
    #       if !@obj
    #         @obj.model           # => "Canon PowerShot G3"
    #         @obj.width           # => 2272
    #         @obj.height          # => 1704
    #         @obj.focal_length    # => 100/1
    #         @obj.gps.latitude    # => 52.7197888888889
    #         @obj.gps.longitude   # => 5.28397777777778
    #         @obj.gps.altitude    # => 444
    #       end

    #      @group = Group.find(@photo.group_id)
    #      redirect_to @group
    #   else
    #     render :new 
    #   end
   redirect_to @group
  end

  # PATCH/PUT /photos/1
  # PATCH/PUT /photos/1.json
  def update
    respond_to do |format|
      if @photo.update(photo_params)
        format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.json
  def destroy
    @group = Group.find(@photo.group_id)
    @photo.destroy
    redirect_to @group
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_photo
      @photo = Photo.find(params[:id])
      @group = Group.find(@photo.group_id)
      @user = User.find(session[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def photo_params
      params.require(:photo).permit(:name, :group_id, :avatar)
    end
end
