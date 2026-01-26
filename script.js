// Navbar scroll effect
const navbar = document.getElementById('navbar');

window.addEventListener('scroll', () => {
    if (window.scrollY > 50) {
        navbar.classList.add('scrolled');
    } else {
        navbar.classList.remove('scrolled');
    }
});

// Smooth scrolling for navigation links
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Intersection Observer for animations
const observerOptions = {
    threshold: 0.1,
    rootMargin: '0px 0px -100px 0px'
};

const observer = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
        if (entry.isIntersecting) {
            entry.target.style.opacity = '1';
            entry.target.style.transform = 'translateY(0)';
        }
    });
}, observerOptions);

// Observe elements for scroll animations
document.querySelectorAll('.service-card, .certification-card, .blog-card, .image-card').forEach(el => {
    el.style.opacity = '0';
    el.style.transform = 'translateY(30px)';
    el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
    observer.observe(el);
});

// Form submission handler
const contactForm = document.getElementById('contactForm');
if (contactForm) {
    contactForm.addEventListener('submit', (e) => {
        e.preventDefault();
        
        // Get current language from HTML lang attribute
        const currentLang = document.documentElement.lang;
        
        let message = '';
        if (currentLang === 'es') {
            message = '¡Gracias por tu mensaje! Te responderé lo antes posible.';
        } else if (currentLang === 'en') {
            message = 'Thank you for your message! I will respond as soon as possible.';
        } else if (currentLang === 'fr') {
            message = 'Merci pour votre message! Je vous répondrai dans les plus brefs délais.';
        }
        
        alert(message);
        contactForm.reset();
    });
}
//Banner rotativo
function inciarBannerRotativo(){
    const imagenes = document.querySelectorAll('#bannerRotativo .banner-img');
    let indiceActual =0;

    setInterval(() =>{
        //Quitar clase active de la imagen actual
        imagenes[inciarBannerRotativo].classList.remove('active');

        //Avanzar al siguiente indice (vuelve a 0 si llega al final)
        indiceActual = (indiceActual + 1) % imagenes.length;

        //Agregar clase active a la nueva imagen
        imagenes[indiceActual].classList.add('active');
    }, 300); //cambia cada 3 segundos
}
//Iniciar cuando el DOM este listo
document.addEventListener('DOMContentLoaded', inciarBannerRotativo):
