import Swal from 'sweetalert2'


export const sweetalert2 = () => {

    const submit = document.querySelector("#submit-btn")
    const form = document.querySelector("#new_booking")
    submit.addEventListener("click", (e) => {
        e.preventDefault();
        Swal.fire({
            title: "Do you want to book this Kondo?",
            icon: "question",
            showDenyButton: true,
            showCancelButton: false,
            confirmButtonText: 'Confirm',
            denyButtonText: 'Cancel',
            reverseButtons: true,
            confirmButtonColor: '#167FFB',
            customClass: {
              actions: 'my-actions',
              cancelButton: 'order-1 right-gap',
              confirmButton: 'order-2',
              denyButton: 'order-3',
            }
          }).then((result) => {
            if (result.isConfirmed) {
                let timerInterval
                Swal.fire({
                  title: 'Processing your booking now',
                  timer: 2000,
                  didOpen: () => {
                    Swal.showLoading()
                    const b = Swal.getHtmlContainer().querySelector('b')
                    timerInterval = setInterval(() => {
                      b.textContent = Swal.getTimerLeft()
                    }, 100)
                  },
                  willClose: () => {
                    clearInterval(timerInterval)
                  }
                }).then((result) => {
                  if (result.dismiss === Swal.DismissReason.timer) {
                    form.submit();
                  }
                })
            } else if (result.isDenied) {
              Swal.fire({
                  title: "Booking Canceled",
                  icon: "error",
                  confirmButtonColor: '#167FFB'
              })
            }
          })
    })
}