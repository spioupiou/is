export const autoSubmit = () => {
    const checkBoxes = document.querySelectorAll(".form-check-input");
    const select = document.querySelector("#search_prefecture")
    const form = document.querySelector('form');
    
      for (const check of checkBoxes) {
        check.addEventListener('change', () => {
          Rails.fire(form, 'submit');
      });
    }

    select.addEventListener("change", () => {
      Rails.fire(form, 'submit');
    })
}