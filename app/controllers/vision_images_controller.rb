class VisionImagesController < ApplicationController
  def new
    @vision_image = VisionImage.new
  end

  def create
    @vision_image = VisionImage.new(vision_images_params)
    if @vision_image.save
      tags = Vision.get_image_data(@vision_image.image, "label")
      tags.each do |tag|
        @vision_image.tags.create(name: tag[0], score: tag[1])
      end
      # landmarks.each do |landmark|
      # a = @vision_image.landmarks.create(name: landmark[0],score: landmark[1],locations: landmark[2])
      # latlng = a.locations.scan(/[+\-]?\d{1,3}.\d{1,14}/)
      # lat = latlng[0]
      # lng = latlng[1]
      # a.latitude = lat
      # a.longitude = lng
      # a.save
      # end
      landmarks = Vision.get_image_data(@vision_image.image, "landmark").flatten
      # landmarkがあるか確認
      if landmarks.blank?
      else
        @vision_image.landmarks.create(
          name: landmarks[0],
          score: landmarks[1],
          locations: landmarks[2],
          latitude: landmarks[2]["latLng"]["latitude"],
          longitude: landmarks[2]["latLng"]["longitude"]
        )
      end
      redirect_to vision_image_path(@vision_image)
    else
      render :new
    end
  end

  def show
    @vision_image = VisionImage.find(params[:id])
    @landmarks = []
    img_landmarks = @vision_image.landmarks
    img_landmarks.each do |landmark|
      latlng = {}
      latlng[:latitude] = landmark.latitude
      latlng[:longitude] = landmark.longitude
      latlng[:name] = landmark.name
      @landmarks << latlng
    end

    @hash = Gmaps4rails.build_markers(@landmarks) do |landmark, marker|
      marker.lat landmark[:latitude]
      marker.lng landmark[:longitude]
      marker.infowindow landmark[:name]
    end
  end

  private

  def vision_images_params
    params.require(:vision_image).permit(:image)
  end
end
