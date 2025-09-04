String getColorNameFromRgb(int r, int g, int b) {
  // Amarillo: alto en rojo y verde, bajo en azul
  if (r >= 180 && g >= 180 && b <= 120) return 'yellow';

  // Naranja: alto en rojo, medio en verde, bajo en azul
  if (r >= 200 && g >= 100 && g <= 180 && b <= 100) return 'orange';

  // Rojo: alto en rojo, bajo en verde y azul
  if (r >= 180 && g <= 100 && b <= 100) return 'red';

  // Verde: alto en verde, bajo en rojo y azul
  if (g >= 150 && r <= 120 && b <= 120) return 'green';

  // Azul: alto en azul, bajo en rojo y verde
  if (b >= 150 && (r <= 200 && g <= 200)) return 'blue';

  // Morado / Púrpura: alto en rojo y azul, bajo en verde
  if (r >= 150 && b >= 150 && g <= 100) return 'purple';

  // Negro: todos muy bajos
  if (r <= 50 && g <= 50 && b <= 50) return 'black';

  // Blanco: todos muy altos
  if (r >= 200 && g >= 200 && b >= 200) return 'white';

  // Gris: todos similares entre 100-200
  if ((r - g).abs() <= 15 && (r - b).abs() <= 15 && (g - b).abs() <= 15) {
    return 'gray';
  }

  return 'unknown';
}
