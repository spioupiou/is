import Splide from '@splidejs/splide';

const initSplide = () => {
  const slides = document.querySelector('.splide')

  if (!!slides) {
    const splide = new Splide(slides, {
      fixedWidth: 400,
      fixedHeight: 300,
      gap: 10,
      pagination: false,
      cover: true,
      breakpoints: {
        560: {
          fixedWidth: 100,
          fixedHeight: 200,
        },
      },
    })
    splide.mount()
  }
}

export { initSplide };
