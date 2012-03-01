#ifndef __GLOBAL_H__
#define __GLOBAL_H__

#define GRADOS_A_RADIANES(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)

#define PANORAMICO true
#define MULTITOUCH true
#define kRenderingFrequency 60.0
#define kZNear			0.01
#define kZFar			1000.0
#define kFieldOfView	60.0

#if __cplusplus
extern "C" {
#endif

typedef enum {
	INICIADO,
	ESTACIONADO,
	MOVIDO,
	LEVANTADO,
	CANCELADO
} Fase;
typedef struct {
	Fase fase;
	int nTaps;
	int x;
	int y;
} Touch;

//Funciones wrapper
void wrapSetPantalla(bool panoramico);

//Funciones main
void init();
void setup(int ancho, int alto);
void getTouches(const Touch *vTouches, int nTouches);
void loop();

#if __cplusplus
}
#endif

#endif