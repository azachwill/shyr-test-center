let sURL = window.location.href;
      if ( sURL.indexOf("r/articles")  >= 0 ) {
        document.querySelector("#quarto-announcement").style.display = "none";
        document.querySelector("#quarto-announcement").style.visibility = "hidden";
        document.querySelector("#open_preferences_center").style.display = "none";
        document.querySelector("#open_preferences_center").style.visibility = "hidden";
      }
