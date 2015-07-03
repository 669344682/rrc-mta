previewImages = {}
previewImages.callback = nil

function previewImages:require(ondownloaded)
	self.callback = ondownloaded
	triggerServerEvent("tws-requireVehiclesPreviews", resourceRoot)
end

addEvent("tws-vehiclesPreviewsDownloaded", true)
addEventHandler("tws-vehiclesPreviewsDownloaded", root, 
	function(imagesList)
		if previewImages.callback then
			previewImages.callback(imagesList)
			previewImages.callback = nil
		end
	end
)