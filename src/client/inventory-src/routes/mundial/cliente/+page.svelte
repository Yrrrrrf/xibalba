<script lang="ts">
  import LocationSelector from "$lib/components/cliente/LocationSelector.svelte";
  import FoodCard from "$lib/components/cliente/FoodCard.svelte";
  import SavedFoodCard from "$lib/components/cliente/SavedFoodCard.svelte";
  import MapView from "$lib/components/ui/MapView.svelte";
  import FoodDetailModal from "$lib/components/cliente/FoodDetailModal.svelte";
  import PlaceCard from "$lib/components/cliente/PlaceCard.svelte";

  const platillos = [
    {
      id: 1,
      nombre: "Tacos al Pastor x3",
      precio: 7.5,
      restaurante: "Taquería El Campeón",
      imagen: "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&q=80",
      categoria: "Mexicana",
      rating: 4.8,
      likes: 234,
      descripcion: "Auténticos tacos al pastor con carne de cerdo marinada en achiote, servidos en tortilla de maíz artesanal con piña, cilantro y cebolla.",
      ingredientes: ["Tortilla de maíz", "Carne de cerdo", "Achiote", "Piña", "Cilantro", "Cebolla", "Salsa verde", "Limón"],
      nutricion: { calorias: 420, proteinas: 24, grasas: 18, carbohidratos: 38 },
      comercio: { id: 1, nombre: "Taquería El Campeón", categoria: "Comida Mexicana", direccion: "Centro Histórico #42", rating: 4.8, lat: 19.4326, lng: -99.1332, abierto: true },
    },
    {
      id: 2,
      nombre: "Ceviche Mixto Grande",
      precio: 12.0,
      restaurante: "La Perla del Mar",
      imagen: "https://content.skyscnr.com/m/2dcd7d0e6f086057/original/GettyImages-186142785.jpg?resize=1224%3Aauto",
      categoria: "Mariscos",
      rating: 4.9,
      likes: 189,
      descripcion: "Ceviche fresco de camarón, pulpo y callo de hacha macerado en limón real, con chile serrano, tomate y pepino crujiente.",
      ingredientes: ["Camarón", "Pulpo", "Callo de hacha", "Limón", "Chile serrano", "Tomate", "Pepino", "Cilantro", "Cebolla morada"],
      nutricion: { calorias: 280, proteinas: 32, grasas: 6, carbohidratos: 14 },
      comercio: { id: 2, nombre: "La Perla del Mar", categoria: "Mariscos", direccion: "Av. Costera Norte 8", rating: 4.9, lat: 19.4351, lng: -99.129, abierto: true },
    },
    {
      id: 3,
      nombre: "Quesadilla de Champiñones",
      precio: 5.0,
      restaurante: "La Comal de Doña Rosa",
      imagen: "https://images.unsplash.com/photo-1618040996337-56904b7850b9?w=400&q=80",
      categoria: "Vegetariano",
      rating: 4.6,
      likes: 98,
      descripcion: "Quesadilla de comal en tortilla de harina con champiñones salteados con epazote, queso Oaxaca y chile poblano asado.",
      ingredientes: ["Tortilla de harina", "Champiñones", "Queso Oaxaca", "Chile poblano", "Epazote", "Ajo", "Mantequilla"],
      nutricion: { calorias: 340, proteinas: 14, grasas: 16, carbohidratos: 34 },
      comercio: { id: 3, nombre: "La Comal de Doña Rosa", categoria: "Comida Mexicana", direccion: "Mercado Central 5", rating: 4.6, lat: 19.4298, lng: -99.137, abierto: false },
    },
    {
      id: 4,
      nombre: "Birria de Res con Consomé",
      precio: 11.0,
      restaurante: "El Birriería Jalisco",
      imagen: "https://healthysimpleyum.com/wp-content/uploads/2024/07/enchiladas-michoacanas-edited-1024x769.jpg",
      categoria: "Mexicana",
      rating: 4.7,
      likes: 312,
      descripcion: "Birria estilo Jalisco de res deshebrada con consomé especiado, servida con tortillas de maíz tatemadas, cebolla y cilantro.",
      ingredientes: ["Res", "Chile guajillo", "Chile ancho", "Jitomate", "Cebolla", "Ajo", "Comino", "Orégano", "Tortilla de maíz"],
      nutricion: { calorias: 580, proteinas: 42, grasas: 28, carbohidratos: 30 },
      comercio: { id: 4, nombre: "El Birriería Jalisco", categoria: "Comida Mexicana", direccion: "Calle Jalisco 18", rating: 4.7, lat: 19.431, lng: -99.131, abierto: true },
    },
    {
      id: 5,
      nombre: "Elote Preparado",
      precio: 3.5,
      restaurante: "Antojitos La Esquina",
      imagen: "https://editorialtelevisa.brightspotcdn.com/be/e8/048fc5974cff83cb8a4ddfe83d66/elote-preparado.jpg",
      categoria: "Antojitos",
      rating: 4.5,
      likes: 76,
      descripcion: "Elote tierno en vaso con mayonesa, queso cotija rallado, chile piquín y unas gotas de limón. El antojito favorito del estadio.",
      ingredientes: ["Elote", "Mayonesa", "Queso cotija", "Chile piquín", "Limón", "Sal"],
      nutricion: { calorias: 220, proteinas: 6, grasas: 10, carbohidratos: 28 },
      comercio: { id: 5, nombre: "Antojitos La Esquina", categoria: "Antojitos", direccion: "Estadio Blvd. s/n", rating: 4.5, lat: 19.437, lng: -99.1355, abierto: true },
    },
    {
      id: 6,
      nombre: "Agua de Jamaica 1L",
      precio: 2.0,
      restaurante: "Refresquería Fresca",
      imagen: "https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400&q=80",
      categoria: "Bebidas",
      rating: 4.4,
      likes: 55,
      descripcion: "Agua fresca de flor de Jamaica preparada con azúcar de caña natural y canela. Refrescante, antioxidante y perfecta para el calor.",
      ingredientes: ["Flor de Jamaica", "Agua purificada", "Azúcar de caña", "Canela", "Hielo"],
      nutricion: { calorias: 90, proteinas: 0, grasas: 0, carbohidratos: 22 },
      comercio: { id: 6, nombre: "Refresquería Fresca", categoria: "Bebidas", direccion: "Fan Fest Zona A", rating: 4.4, lat: 19.434, lng: -99.128, abierto: true },
    },
    {
      id: 7,
      nombre: "Churros con Cajeta",
      precio: 4.0,
      restaurante: "Dulcería Mundial",
      imagen: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQqqBdZeK72MFOUxSfZikCufEeAiV-mukgDxw&s",
      categoria: "Postres",
      rating: 4.7,
      likes: 143,
      descripcion: "Churros crujientes fritos al momento, bañados en cajeta de Celaya y espolvoreados con azúcar y canela. Postre irresistible del Fan Fest.",
      ingredientes: ["Harina de trigo", "Aceite", "Cajeta", "Azúcar", "Canela", "Sal"],
      nutricion: { calorias: 480, proteinas: 6, grasas: 22, carbohidratos: 64 },
      comercio: { id: 7, nombre: "Dulcería Mundial", categoria: "Postres", direccion: "Plaza Fan Fest", rating: 4.7, lat: 19.4285, lng: -99.1345, abierto: true },
    },
    {
      id: 8,
      nombre: "Tostada de Tinga",
      precio: 6.0,
      restaurante: "La Tostadería",
      imagen: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS9UrDMETB3iAHc6LIzJAlJn9EI5TQ_pW7ZTQ&s",
      categoria: "Mexicana",
      rating: 4.3,
      likes: 67,
      descripcion: "Tostada de tinga de pollo con chipotle, sobre frijoles refritos en tostada horneada, crema, lechuga y queso fresco.",
      ingredientes: ["Pollo deshebrado", "Chile chipotle", "Jitomate", "Cebolla", "Frijoles refritos", "Tostada", "Crema", "Queso fresco", "Lechuga"],
      nutricion: { calorias: 310, proteinas: 22, grasas: 12, carbohidratos: 28 },
      comercio: { id: 8, nombre: "Veggie Garden", categoria: "Vegetariano", direccion: "Centro Alt. #9", rating: 4.3, lat: 19.4315, lng: -99.1395, abierto: false },
    },
  ];

  const comerciosMap = [
    {
      id: 1,
      nombre: "Taquería El Campeón",
      categoria: "Comida Mexicana",
      direccion: "Centro Histórico #42",
      rating: 4.8,
      lat: 19.4326,
      lng: -99.1332,
      abierto: true,
    },
    {
      id: 2,
      nombre: "La Perla del Mar",
      categoria: "Mariscos",
      direccion: "Av. Costera Norte 8",
      rating: 4.9,
      lat: 19.4351,
      lng: -99.129,
      abierto: true,
    },
    {
      id: 3,
      nombre: "La Comal de Doña Rosa",
      categoria: "Comida Mexicana",
      direccion: "Mercado Central 5",
      rating: 4.6,
      lat: 19.4298,
      lng: -99.137,
      abierto: false,
    },
    {
      id: 4,
      nombre: "El Birriería Jalisco",
      categoria: "Comida Mexicana",
      direccion: "Calle Jalisco 18",
      rating: 4.7,
      lat: 19.431,
      lng: -99.131,
      abierto: true,
    },
    {
      id: 5,
      nombre: "Antojitos La Esquina",
      categoria: "Antojitos",
      direccion: "Estadio Blvd. s/n",
      rating: 4.5,
      lat: 19.437,
      lng: -99.1355,
      abierto: true,
    },
    {
      id: 6,
      nombre: "Refresquería Fresca",
      categoria: "Bebidas",
      direccion: "Fan Fest Zona A",
      rating: 4.4,
      lat: 19.434,
      lng: -99.128,
      abierto: true,
    },
    {
      id: 7,
      nombre: "Dulcería Mundial",
      categoria: "Postres",
      direccion: "Plaza Fan Fest",
      rating: 4.7,
      lat: 19.4285,
      lng: -99.1345,
      abierto: true,
    },
    {
      id: 8,
      nombre: "Veggie Garden",
      categoria: "Vegetariano",
      direccion: "Centro Alt. #9",
      rating: 4.3,
      lat: 19.4315,
      lng: -99.1395,
      abierto: false,
    },
  ];

  const guardados = [
    {
      id: 1,
      nombre: "Tacos al Pastor x3",
      precio: 7.5,
      restaurante: "Taquería El Campeón",
      imagen:
        "https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&q=80",
      categoria: "Mexicana",
    },
    {
      id: 4,
      nombre: "Birria de Res con Consomé",
      precio: 11.0,
      restaurante: "El Birriería Jalisco",
      imagen:
        "https://images.unsplash.com/photo-1625938145319-0b4e02e15a32?w=400&q=80",
      categoria: "Mexicana",
    },
    {
      id: 7,
      nombre: "Churros con Cajeta",
      precio: 4.0,
      restaurante: "Dulcería Mundial",
      imagen:
        "https://images.unsplash.com/photo-1624372632067-c65716d28484?w=400&q=80",
      categoria: "Postres",
    },
  ];

  // ── HOTELES ──────────────────────────────────────────────────────────
  const hoteles = [
    {
      id: 101, nombre: "Hotel Azteca Grand", tipo: "Hotel 5★",
      descripcion: "Lujoso hotel en el corazón de la CDMX con piscina infinita, spa y vista panorámica al Zócalo.",
      imagen: "https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&q=80",
      direccion: "Av. Juárez 100, Centro", rating: 4.8, precio: "$180/noche",
      distancia: "0.3 km", abierto: true, horario: "24 hrs",
      tags: ["Piscina", "Spa", "Desayuno incluido", "WiFi"],
      colorAccent: "from-amber-400/20 to-yellow-400/10", emoji: "🏨"
    },
    {
      id: 102, nombre: "Hostal Mundialista", tipo: "Hostal",
      descripcion: "Ambiente festivo ideal para turistas. Camas desde $25 USD. Zona de bar y eventos FIFA .",
      imagen: "https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=400&q=80",
      direccion: "Calle Uruguay 54, Centro", rating: 4.5, precio: "$25/noche",
      distancia: "0.6 km", abierto: true, horario: "24 hrs",
      tags: ["Bar", "Lockers", "Tours gratis", "Comunidad"],
      colorAccent: "from-orange-400/20 to-red-400/10", emoji: "🛖"
    },
    {
      id: 103, nombre: "Boutique Fan Fest", tipo: "Hotel 4★",
      descripcion: "Hotel boutique a pasos del Fan Fest oficial. Pantallas de 80\" en áreas comunes para ver los partidos.",
      imagen: "https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=400&q=80",
      direccion: "Blvd. Estadio km 2", rating: 4.6, precio: "$95/noche",
      distancia: "1.2 km", abierto: true, horario: "24 hrs",
      tags: ["Fan Zone", "Parking", "Restaurante", "AC"],
      colorAccent: "from-blue-400/20 to-indigo-400/10", emoji: "🏨"
    },
    {
      id: 104, nombre: "Airbnb Casa Tlatelolco", tipo: "Apartamento",
      descripcion: "Casa completa con 3 habitaciones, cocina equipada y terraza con vista. Perfecta para grupos de amigos.",
      imagen: "https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=400&q=80",
      direccion: "Plaza Tlatelolco #8", rating: 4.7, precio: "$60/noche",
      distancia: "2.1 km", abierto: true, horario: "Flexible",
      tags: ["Casa completa", "Cocina", "Terraza", "3 habitaciones"],
      colorAccent: "from-emerald-400/20 to-teal-400/10", emoji: "🏠"
    },
  ];

  // ── LUGARES RECREATIVOS ──────────────────────────────────────────────
  const recreativos = [
    {
      id: 201, nombre: "Fan Fest Oficial FIFA", tipo: "Zona de Fanáticos",
      descripcion: "El Fan Fest oficial del Mundial con pantallas gigantes, comida, conciertos y actividades FIFA.",
      imagen: "https://images.unsplash.com/photo-1509824227185-9c5a01ceba0d?w=400&q=80",
      direccion: "Parque Bicentenario s/n", rating: 4.9, precio: "Gratis",
      distancia: "0.8 km", abierto: true, horario: "10:00 – 23:00",
      tags: ["Pantalla gigante", "Comida", "Conciertos", "Familiar"],
      colorAccent: "from-red-400/20 to-orange-400/10", emoji: "⚽"
    },
    {
      id: 202, nombre: "Museo Nacional de Antropología", tipo: "Museo",
      descripcion: "Uno de los museos más importantes del mundo con más de 45,000 piezas arqueológicas de México.",
      imagen: "https://images.unsplash.com/photo-1518998053901-5348d3961a04?w=400&q=80",
      direccion: "Paseo de la Reforma s/n, Chapultepec", rating: 4.8, precio: "$80 MXN",
      distancia: "3.2 km", abierto: true, horario: "9:00 – 19:00",
      tags: ["Cultura", "Historia", "Aztecas", "Mayas"],
      colorAccent: "from-amber-400/20 to-orange-400/10", emoji: "🏛️"
    },
    {
      id: 203, nombre: "Bosque de Chapultepec", tipo: "Parque Natural",
      descripcion: "El pulmón de la CDMX. Lago artificial, zoológico, museos y espacios para picnic y actividades al aire libre.",
      imagen: "https://images.unsplash.com/photo-1555400038-63f5ba517a47?w=400&q=80",
      direccion: "Chapultepec, Miguel Hidalgo", rating: 4.7, precio: "Gratis",
      distancia: "3.5 km", abierto: true, horario: "5:00 – 20:00",
      tags: ["Naturaleza", "Lago", "Zoológico", "Familia"],
      colorAccent: "from-green-400/20 to-emerald-400/10", emoji: "🌳"
    },
    {
      id: 204, nombre: "Xochimilco Trajineras", tipo: "Turismo Acuático",
      descripcion: "Paseo en trajinera por los canales de Xochimilco, Patrimonio UNESCO. Música de mariachis incluida.",
      imagen: "https://images.unsplash.com/photo-1500534314209-a25ddb2bd429?w=400&q=80",
      direccion: "Embarcadero Nuevo Nativitas", rating: 4.6, precio: "$300 MXN",
      distancia: "12 km", abierto: true, horario: "9:00 – 18:00",
      tags: ["UNESCO", "Mariachis", "Flores", "Foto]"],
      colorAccent: "from-cyan-400/20 to-blue-400/10", emoji: "🛶"
    },
    {
      id: 205, nombre: "Lucha Libre Arena México", tipo: "Entretenimiento",
      descripcion: "¡Vive la experiencia única de la Lucha Libre! Shows los martes, viernes y domingos con luchadores legendarios.",
      imagen: "https://images.unsplash.com/photo-1561484930-998b6a7b22e8?w=400&q=80",
      direccion: "Dr. Lavista 189, Doctores", rating: 4.8, precio: "$150 MXN",
      distancia: "4.1 km", abierto: true, horario: "Mar/Vie/Dom 20:00",
      tags: ["Lucha Libre", "Icónico", "Show", "CDMX"],
      colorAccent: "from-purple-400/20 to-pink-400/10", emoji: "🤼"
    },
    {
      id: 206, nombre: "Palacio de Bellas Artes", tipo: "Arte y Cultura",
      descripcion: "El principal recinto cultural de México. Exposiciones de Diego Rivera, conciertos y ballet folklórico.",
      imagen: "https://images.unsplash.com/photo-1505761671935-60b3a7427bad?w=400&q=80",
      direccion: "Eje Central Lázaro Cárdenas s/n", rating: 4.9, precio: "Gratis (exterior)",
      distancia: "0.5 km", abierto: true, horario: "10:00 – 17:00",
      tags: ["Arte", "Murales", "Ballet", "Ópera"],
      colorAccent: "from-rose-400/20 to-pink-400/10", emoji: "🎭"
    },
  ];

  // ── BAÑOS Y SERVICIOS ────────────────────────────────────────────────
  const servicios = [
    {
      id: 301, nombre: "Baños Públicos Zócalo", tipo: "Baños Públicos",
      descripcion: "Instalaciones limpias y seguras con sanitarios, lavabos y cambiadores para bebés en el Zócalo.",
      imagen: "https://images.unsplash.com/photo-1563453392212-326f5e854473?w=400&q=80",
      direccion: "Plaza de la Constitución s/n", rating: 3.9, precio: "$5 MXN",
      distancia: "0.1 km", abierto: true, horario: "7:00 – 22:00",
      tags: ["Accesible", "Cambiador", "Limpio"],
      colorAccent: "from-sky-400/20 to-blue-400/10", emoji: "🚻"
    },
    {
      id: 302, nombre: "Servicios OXXO Centro", tipo: "Baños + Tienda",
      descripcion: "Acceso a baños disponible para clientes. Tienda con snacks, bebidas y artículos de primeros auxilios.",
      imagen: "https://images.unsplash.com/photo-1604719312566-8912e9667d9f?w=400&q=80",
      direccion: "Av. 5 de Mayo #32", rating: 3.5, precio: "Gratis (clientes)",
      distancia: "0.4 km", abierto: true, horario: "24 hrs",
      tags: ["24 hrs", "Tienda", "Snacks", "ATM"],
      colorAccent: "from-red-400/20 to-orange-400/10", emoji: "🏪"
    },
    {
      id: 303, nombre: "Estación del Metro Zócalo", tipo: "Transporte + Servicios",
      descripcion: "Estación con baños, cajeros ATM, acceso a toda la red del metro. La forma más económica de moverte.",
      imagen: "https://images.unsplash.com/photo-1565966166965-e4e1c63d4e91?w=400&q=80",
      direccion: "Pino Suárez, Centro Histórico", rating: 4.1, precio: "$5 MXN (metro)",
      distancia: "0.2 km", abierto: true, horario: "5:00 – 0:30",
      tags: ["Metro", "ATM", "Baños", "Transporte"],
      colorAccent: "from-amber-400/20 to-yellow-400/10", emoji: "🚇"
    },
    {
      id: 304, nombre: "Centro Médico Fan Zone", tipo: "Primeros Auxilios",
      descripcion: "Enfermeras y médicos de guardia durante todos los eventos del Mundial. Atención gratuita para turistas.",
      imagen: "https://images.unsplash.com/photo-1538108149393-fbbd81895907?w=400&q=80",
      direccion: "Fan Fest Zona B, Puerta 3", rating: 4.7, precio: "Gratis",
      distancia: "1.0 km", abierto: true, horario: "8:00 – 23:00",
      tags: ["Emergencias", "Médico", "Gratuito", "FIFA"],
      colorAccent: "from-emerald-400/20 to-green-400/10", emoji: "🏥"
    },
    {
      id: 305, nombre: "Oficina de Turismo FIFA", tipo: "Información Turística",
      descripcion: "Centro oficial de atención al turista. Mapas, guías, asistencia en 12 idiomas y resolución de problemas.",
      imagen: "https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?w=400&q=80",
      direccion: "Av. Reforma 222, PB", rating: 4.6, precio: "Gratis",
      distancia: "2.0 km", abierto: true, horario: "8:00 – 20:00",
      tags: ["Idiomas", "Guías", "Mapas", "FIFA Official"],
      colorAccent: "from-indigo-400/20 to-purple-400/10", emoji: "ℹ️"
    },
  ];

  // ── REGISTRO Y EVENTOS ────────────────────────────────────────────────
  const registros = [
    {
      id: 401, nombre: "Registro Fan ID Mundial", tipo: "Registro Oficial",
      descripcion: "Obtén tu Fan ID oficial FIFA para acceder a zonas exclusivas, descuentos y beneficios especiales durante el torneo.",
      imagen: "https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=400&q=80",
      direccion: "Centro de Convenciones Banamex", rating: 4.8, precio: "Gratis",
      distancia: "5.0 km", abierto: true, horario: "9:00 – 18:00",
      tags: ["FIFA Oficial", "Credencial", "Beneficios", "Gratuito"],
      colorAccent: "from-orange-400/20 to-amber-400/10", emoji: "🪪"
    },
    {
      id: 402, nombre: "Tour Estadio Azteca", tipo: "Tour Oficial",
      descripcion: "Recorrido guiado por el mítico Estadio Azteca: vestidores, cancha, museo de trofeos y palcos VIP.",
      imagen: "https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400&q=80",
      direccion: "Calz. de Tlalpan 3465, Coyoacán", rating: 4.9, precio: "$250 MXN",
      distancia: "11 km", abierto: true, horario: "10:00 – 17:00",
      tags: ["Tour", "Estadio Azteca", "VIP", "Museo"],
      colorAccent: "from-purple-400/20 to-violet-400/10", emoji: "🏟️"
    },
    {
      id: 403, nombre: "Expo Gastronomía Mundial", tipo: "Evento Cultural",
      descripcion: "Feria gastronómica con chefs de las 32 naciones participantes. Degustaciones, show cooking y concursos.",
      imagen: "https://images.unsplash.com/photo-1532635241-17e820acc59f?w=400&q=80",
      direccion: "Arena Ciudad de México", rating: 4.7, precio: "$180 MXN",
      distancia: "6.5 km", abierto: true, horario: "12:00 – 22:00",
      tags: ["Gastronomía", "32 países", "Chefs", "Degustación"],
      colorAccent: "from-rose-400/20 to-red-400/10", emoji: "🍽️"
    },
    {
      id: 404, nombre: "Voluntario FIFA 2026", tipo: "Voluntariado",
      descripcion: "Regístrate como voluntario oficial del Mundial. Capacitación, uniforme oficial y experiencia única.",
      imagen: "https://images.unsplash.com/photo-1559027615-cd4628902d4a?w=400&q=80",
      direccion: "FIFA HQ México — Polanco", rating: 4.9, precio: "Gratis",
      distancia: "4.8 km", abierto: true, horario: "Lun–Vie 9:00–17:00",
      tags: ["Voluntario", "Uniforme", "FIFA", "Experiencia"],
      colorAccent: "from-green-400/20 to-emerald-400/10", emoji: "🙋"
    },
    {
      id: 405, nombre: "Mercado Artesanal Mexicano", tipo: "Mercado Cultural",
      descripcion: "Artesanías auténticas de los 32 estados de México: barro negro, textiles, plata, talavera y más.",
      imagen: "https://images.unsplash.com/photo-1555633514-abcee6ab92e1?w=400&q=80",
      direccion: "Ciudadela, Centro", rating: 4.6, precio: "Entrada libre",
      distancia: "1.5 km", abierto: true, horario: "10:00 – 19:00",
      tags: ["Artesanías", "Souvenirs", "Textiles", "Plata"],
      colorAccent: "from-yellow-400/20 to-amber-400/10", emoji: "🎨"
    },
  ];

  const categorias = [
    "Todos",
    "Mexicana",
    "Mariscos",
    "Antojitos",
    "Bebidas",
    "Postres",
    "Vegetariano",
  ];
  let categoriaActiva = $state("Todos");
  let activeTab = $state<"explorar" | "hoteles" | "recreativo" | "servicios" | "registro" | "mapa" | "guardados">("explorar");
  let selectedFood = $state<typeof platillos[0] | null>(null);
  let isDetailOpen = $state(false);

  function openDetail(p: typeof platillos[0]) {
    selectedFood = p;
    isDetailOpen = true;
  }

  function closeDetail() {
    isDetailOpen = false;
    selectedFood = null;
  }

  const platillosFiltrados = $derived(
    categoriaActiva === "Todos"
      ? platillos
      : platillos.filter((p) => p.categoria === categoriaActiva),
  );

  const categoryEmoji: Record<string, string> = {
    Todos: "🍽️",
    Mexicana: "🌮",
    Mariscos: "🦐",
    Antojitos: "🫔",
    Bebidas: "🥤",
    Postres: "🍩",
    Vegetariano: "🥗",
  };
</script>

<svelte:head>
  <title>Mundial Food — Turista</title>
  <meta
    name="description"
    content="Descubre los mejores platillos cerca de ti durante el Mundial"
  />
</svelte:head>

<main class="container mx-auto px-4 pt-20 pb-10 max-w-6xl">
  <!-- ── HERO HEADER ──────────────────────────────────────── -->
  <div class="mb-8">
    <div
      class="inline-flex items-center gap-2 px-3 py-1 rounded-full
                  bg-orange-500/10 border border-orange-500/20 text-orange-400
                  text-[10px] font-bold uppercase tracking-widest mb-3 backdrop-blur-sm"
    >
      <span class="animate-pulse">●</span>
      <span>258 negocios abiertos cerca de ti</span>
    </div>
    <h1 class="text-3xl font-extrabold text-neutral-100 tracking-tight">
      ¡Hola, Viajero! 👋
    </h1>
    <p class="text-neutral-500 text-xs mt-1 font-medium italic">
      Descubre la gastronomía más auténtica del Mundial
    </p>
  </div>

  <!-- ── LOCATION SELECTOR (glass card) ─────────────────── -->
  <div
    class="bg-neutral-900/40 backdrop-blur-xl border border-white/10
                shadow-2xl
                rounded-2xl mb-6 overflow-hidden"
  >
    <LocationSelector />
  </div>

  <!-- ── TABS (glass pill tabs) ───────────────────────────── -->
  <div
    class="flex gap-2 mb-6 p-1.5
                bg-neutral-900/60 backdrop-blur-md border border-white/10
                rounded-2xl shadow-xl w-fit"
  >
    {#each [
      { id: "explorar", label: "🔍 Explorar" },
      { id: "hoteles", label: "🏨 Hoteles" },
      { id: "recreativo", label: "🎡 Recreativo" },
      { id: "servicios", label: "🚻 Servicios" },
      { id: "registro", label: "📋 Registro" },
      { id: "mapa", label: "🗺️ Mapa" },
      { id: "guardados", label: "❤️ Guardados" },
    ] as tab}
      <button
        onclick={() => {
          activeTab = tab.id as "explorar" | "hoteles" | "recreativo" | "servicios" | "registro" | "mapa" | "guardados";
        }}
        class="relative px-4 py-2 rounded-xl text-[10px] font-bold uppercase tracking-widest
                 transition-all duration-400
                 {activeTab === tab.id
          ? 'bg-orange-500 text-white shadow-lg shadow-orange-950/20'
          : 'text-neutral-500 hover:text-neutral-300 hover:bg-white/5'}"
      >
        {tab.label}
        {#if tab.id === "guardados"}
          <span
            class="ml-1 text-[9px] font-extrabold px-1.5 py-0.5 rounded-full
                         {activeTab === 'guardados'
              ? 'bg-white/20 text-white'
              : 'bg-orange-500/20 text-orange-400'}"
          >
            {guardados.length}
          </span>
        {/if}
      </button>
    {/each}
  </div>

  <!-- ════════════════════════════
         TAB: EXPLORAR
    ════════════════════════════ -->
  {#if activeTab === "explorar"}
    <!-- Category filters -->
    <div class="flex gap-2 overflow-x-auto pb-3 mb-7 scrollbar-hide">
      {#each categorias as cat}
        <button
          onclick={() => {
            categoriaActiva = cat;
          }}
          class="flex items-center gap-2 px-4 py-2 rounded-full text-[11px] font-bold uppercase tracking-wider
                   flex-shrink-0 border transition-all duration-300
                   {categoriaActiva === cat
            ? 'bg-orange-500 text-white border-orange-500 shadow-lg shadow-orange-900/20'
            : 'bg-neutral-900/40 backdrop-blur-sm text-neutral-400 border-white/10 hover:bg-white/5'}"
        >
          <span>{categoryEmoji[cat] ?? "🍽️"}</span>
          <span>{cat}</span>
        </button>
      {/each}
    </div>

    <!-- Food grid with perspective container for 3D -->
    <div
      class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 pb-12"
      style="perspective: 2000px;"
    >
      {#each platillosFiltrados as platillo}
        <FoodCard {...platillo} onselect={() => openDetail(platillo)} />
      {/each}
    </div>

    {#if platillosFiltrados.length === 0}
      <div class="text-center py-20">
        <p class="text-5xl mb-3">🔍</p>
        <p class="text-stone-400 font-medium">
          Sin platillos en esta categoría
        </p>
      </div>
    {/if}

    <!-- ════════════════════════════
         TAB: HOTELES
    ════════════════════════════ -->
  {:else if activeTab === "hoteles"}
    <div class="mb-5 flex items-center justify-between">
      <div>
        <h2 class="text-lg font-extrabold text-neutral-100">🏨 Alojamientos cerca de ti</h2>
        <p class="text-neutral-500 text-xs mt-0.5">Hoteles, hostales y apartamentos para tu estadía</p>
      </div>
      <span class="px-3 py-1.5 rounded-full text-[10px] font-bold uppercase tracking-widest
                   bg-amber-500/10 text-amber-400 border border-amber-500/20">
        {hoteles.length} opciones
      </span>
    </div>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6 pb-12"
         style="perspective: 2000px;">
      {#each hoteles as lugar}
        <PlaceCard {...lugar} />
      {/each}
    </div>

    <!-- ════════════════════════════
         TAB: RECREATIVO
    ════════════════════════════ -->
  {:else if activeTab === "recreativo"}
    <div class="mb-5 flex items-center justify-between">
      <div>
        <h2 class="text-lg font-extrabold text-neutral-100">🎡 Lugares Recreativos</h2>
        <p class="text-neutral-500 text-xs mt-0.5">Museos, parques, fan zones y entretenimiento</p>
      </div>
      <span class="px-3 py-1.5 rounded-full text-[10px] font-bold uppercase tracking-widest
                   bg-red-500/10 text-red-400 border border-red-500/20">
        {recreativos.length} lugares
      </span>
    </div>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 pb-12"
         style="perspective: 2000px;">
      {#each recreativos as lugar}
        <PlaceCard {...lugar} />
      {/each}
    </div>

    <!-- ════════════════════════════
         TAB: SERVICIOS
    ════════════════════════════ -->
  {:else if activeTab === "servicios"}
    <div class="mb-5 flex items-center justify-between">
      <div>
        <h2 class="text-lg font-extrabold text-neutral-100">🚻 Servicios y Baños</h2>
        <p class="text-neutral-500 text-xs mt-0.5">Baños públicos, atención médica e información turística</p>
      </div>
      <span class="px-3 py-1.5 rounded-full text-[10px] font-bold uppercase tracking-widest
                   bg-sky-500/10 text-sky-400 border border-sky-500/20">
        {servicios.length} puntos
      </span>
    </div>
    <!-- Emergency highlight banner -->
    <div class="flex items-center gap-3 p-3 mb-5 rounded-2xl
                bg-emerald-500/5 border border-emerald-500/15 text-emerald-400 text-xs font-medium">
      <span class="text-lg">🏥</span>
      <span>Atención médica <strong>gratuita</strong> disponible en Fan Fest Zona B — disponible hasta las 23:00</span>
    </div>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 pb-12"
         style="perspective: 2000px;">
      {#each servicios as lugar}
        <PlaceCard {...lugar} />
      {/each}
    </div>

    <!-- ════════════════════════════
         TAB: REGISTRO
    ════════════════════════════ -->
  {:else if activeTab === "registro"}
    <div class="mb-5 flex items-center justify-between">
      <div>
        <h2 class="text-lg font-extrabold text-neutral-100">📋 Registro y Eventos</h2>
        <p class="text-neutral-500 text-xs mt-0.5">Registro Fan ID, tours, eventos y voluntariado</p>
      </div>
      <span class="px-3 py-1.5 rounded-full text-[10px] font-bold uppercase tracking-widest
                   bg-orange-500/10 text-orange-400 border border-orange-500/20">
        {registros.length} actividades
      </span>
    </div>
    <!-- Featured banner -->
    <div class="flex items-center gap-3 p-3 mb-5 rounded-2xl
                bg-orange-500/5 border border-orange-500/15 text-orange-400 text-xs font-medium">
      <span class="text-lg">🪪</span>
      <span>Regístrate gratis para obtener tu <strong>Fan ID oficial FIFA</strong> y acceder a descuentos y zonas exclusivas</span>
    </div>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 pb-12"
         style="perspective: 2000px;">
      {#each registros as lugar}
        <PlaceCard {...lugar} />
      {/each}
    </div>

    <!-- ════════════════════════════
         TAB: MAPA
    ════════════════════════════ -->
  {:else if activeTab === "mapa"}
    <div class="space-y-3">
      <div class="flex items-center justify-between">
        <p class="text-[10px] font-bold uppercase tracking-widest text-neutral-600 italic">
          Haz clic en un marcador para detalles
        </p>
        <span class="px-3 py-1 rounded-full text-[10px] font-bold uppercase tracking-widest
                       bg-emerald-500/10 text-emerald-400 border border-emerald-500/20">
          ● {comerciosMap.filter((c) => c.abierto).length} abiertos ahora
        </span>
      </div>
      <div class="rounded-3xl overflow-hidden shadow-2xl border border-white/10">
        <MapView
          comercios={comerciosMap}
          height="500px"
          showUserLocation={true}
        />
      </div>
    </div>

    <!-- ════════════════════════════
         TAB: GUARDADOS
    ════════════════════════════ -->
  {:else}
    <div class="space-y-4 max-w-lg mx-auto pb-12">
      {#each guardados as item}
        <div
          class="bg-neutral-900/60 backdrop-blur-xl border border-white/10
                      rounded-2xl shadow-xl hover:shadow-orange-500/5
                      hover:-translate-y-0.5 transition-all duration-300"
        >
          <SavedFoodCard {...item} />
        </div>
      {/each}
    </div>
  {/if}


  <!-- Bottom spacer -->
  <div class="h-12"></div>
</main>

<!-- ── FOOD DETAIL MODAL ──────────────────────────────────── -->
<FoodDetailModal
  platillo={selectedFood}
  open={isDetailOpen}
  onclose={closeDetail}
/>
