/* Set the width of the side navigation to 250px */


export const sideNav = () => {
  const opener = document.getElementById("open-nav");
  const menu = document.getElementById("mySidenav");
    opener.addEventListener("click", (e) => {
        menu.style.width = "250px"
        opener.style.display = "none"
      })
    
      menu.addEventListener("click", (e) => {
        e.currentTarget.style.width = "0"
        opener.style.display = ""
      })

}