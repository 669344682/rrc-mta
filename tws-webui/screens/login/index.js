 $("#login-button").click(function(event){
		 event.preventDefault();
	 
	 $('form').fadeOut(500);
	 $('.wrapper').addClass('form-success');
});

function getRandomArbitrary(min, max) {
  return Math.floor(Math.random() * (max - min) + min);
}

$(window).load(function() {
  $('body').css("background", "url('img/background" + getRandomArbitrary(1, 14) +".jpg')")
});