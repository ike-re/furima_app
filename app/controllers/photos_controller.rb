class PhotosController < ApplicationController
  before_action :authenticate_user!
end
