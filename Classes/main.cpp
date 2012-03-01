#include "main.h"

void init() {
	srand(time(NULL));
	for(int i = 0; i < 20; i++) {
		colores[i][0] = 1.0*rand()/RAND_MAX;
		colores[i][1] = 1.0*rand()/RAND_MAX;
		colores[i][2] = 1.0*rand()/RAND_MAX;
		colores[i][3] = 1.0;
	}
	
	animacion = true;
	panoramico = true;
	vel = 1.0;
}

void setup(int ancho, int alto) {
	GLfloat size; 

	anchoPantalla = ancho;
	altoPantalla = alto;
	
	glMatrixMode(GL_PROJECTION); 
	glEnable(GL_DEPTH_TEST);
	size = kZNear * tanf(GRADOS_A_RADIANES(kFieldOfView) / 2.0); 
	glFrustumf(-size, size, -size / (1.0*ancho / alto), size / (1.0*ancho / alto), kZNear, kZFar); 
	glViewport(0, 0, ancho, alto); 
	glMatrixMode(GL_MODELVIEW); 
	glLoadIdentity(); 
	glClearColor(1.0f, 1.0f, 1.0f, 1.0f); 
}

void getTouches(const Touch *vTouches, int nTouches) {
	if(nTouches == 3 && vTouches[0].fase != LEVANTADO && vTouches[1].fase != LEVANTADO && vTouches[2].fase != LEVANTADO)
		animacion = !animacion;
	for(int i = 0; i < nTouches; i++) {
		if(vTouches[i].fase == LEVANTADO && vTouches[i].nTaps == 2) {
			panoramico = !panoramico;
			wrapSetPantalla(panoramico);
		}
		else if(vTouches[i].fase == MOVIDO && vTouches[i].x > anchoPantalla/2)
			vel += 0.05;
		else if(vTouches[i].fase == MOVIDO && vTouches[i].x < anchoPantalla/2)
			vel -= 0.05;
	}
}

void loop() {
	static GLfloat angulo;
	static const GLfloat vertices[]= {
		0, -0.525731, 0.850651,
		0.850651, 0, 0.525731,
		0.850651, 0, -0.525731,
		-0.850651, 0, -0.525731,
		-0.850651, 0, 0.525731,
		-0.525731, 0.850651, 0,
		0.525731, 0.850651, 0,
		0.525731, -0.850651, 0,
		-0.525731, -0.850651, 0,
		0, -0.525731, -0.850651,
		0, 0.525731, -0.850651,
		0, 0.525731, 0.850651
	};
	static const GLubyte caras[] = {
		1, 2, 6,
		1, 7, 2,
		3, 4, 5,
		4, 3, 8,
		6, 5, 11,
		5, 6, 10,
		9, 10, 2,
		10, 9, 3,
		7, 8, 9,
		8, 7, 0,
		11, 0, 1,
		0, 11, 4,
		6, 2, 10,
		1, 6, 11,
		3, 5, 10,
		5, 4, 11,
		2, 7, 9,
		7, 1, 0,
		3, 9, 8,
		4, 8, 0
	};
	static const GLubyte nCaras = 20;
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

	glLoadIdentity(); 
	glEnableClientState(GL_VERTEX_ARRAY);
	glTranslatef(0.0f,0.0f,-3.0f);
	glRotatef(angulo,1.0f,1.0f,1.0f);

	glVertexPointer(3, GL_FLOAT, 0, vertices);
	for(int i = 0; i < nCaras; i++) {
		glColor4f(colores[i%20][0], colores[i%20][1], colores[i%20][2], colores[i%20][3]);
		glDrawElements(GL_TRIANGLES, 3, GL_UNSIGNED_BYTE, &caras[i*3]);
	}
	glDisableClientState(GL_VERTEX_ARRAY);

	if(animacion)
		angulo += vel;
}
