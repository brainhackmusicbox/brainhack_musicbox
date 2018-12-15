#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){

    // About Auto complete
    // Curretry vscode intelisense for C++ has limitation.
    // Try to type m.set and you will see tons of functions and variables includes "set" keyword
    // 
    // more info here https://github.com/Microsoft/vscode-cpptools/issues/13
    // You can use "Peek Definition" feature instead

    ofSetWindowShape(800, 800);
    ofSetFrameRate(60);

    // image.allocate(800, 800, OF_IMAGE_COLOR);
    // image.load("head_unprocesssed.jpg");
    image.load("head.jpg");
    image.resize(200, 200);

    gui.setup();
    gui.add(camX.setup("camX", 0, -1500, 1500));
    gui.add(camY.setup("camY", 0, -1500, 1500));
    gui.add(camZ.setup("camZ", 0, -1500, 1500));

    mesh.setMode(OF_PRIMITIVE_LINES);
    mesh.enableColors();
    mesh.enableIndices();

    float intensityThreshold = 115.0;
    int w = image.getWidth();
    int h = image.getHeight();
    for (int x=0; x<w; ++x) {
        for (int y=0; y<h; ++y) {
            ofColor c = image.getColor(x, y);
            float intensity = c.getLightness();
            
            if (intensity >= intensityThreshold) {
                float saturation = c.getSaturation();
                float z = ofMap(saturation, 0, 255, -100, 100);

                ofVec3f pos(x*4, y*4, z);
                     
                mesh.addVertex(pos);
                mesh.addColor(c);
                
                offsets.push_back(ofVec3f(ofRandom(0,100000), ofRandom(0,100000), ofRandom(0,100000)));
            }
        }
    }
    cout << "threshold: " << intensityThreshold << "------> " << mesh.getNumVertices() << " points found" << endl << endl;

    float connectionDistance = 30;
    int numVerts = mesh.getNumVertices();
    for (int a=0; a<numVerts; ++a) {
        ofVec3f verta = mesh.getVertex(a);

        for (int b=a+1; b<numVerts; ++b) {
            ofVec3f vertb = mesh.getVertex(b);
            float distance = verta.distance(vertb);

            if (distance <= connectionDistance) {
                // In OF_PRIMITIVE_LINES, every pair of vertices or indices will be
                // connected to form a line
                mesh.addIndex(a);
                mesh.addIndex(b);
                }
            }
    }

}

//--------------------------------------------------------------
void ofApp::update(){
    int numVerts = mesh.getNumVertices();

    for (int i=0; i<numVerts; ++i) {
        ofVec3f vert = mesh.getVertex(i);

        float time = ofGetElapsedTimef();
        float timeScale = 1.0;
        float displacementScale = 0.8;
        ofVec3f timeOffsets = offsets[i];

        // A typical design pattern for using Perlin noise uses a couple parameters:
        // ofSignedNoise(time*timeScale+timeOffset)*displacementScale
        //     ofSignedNoise(time) gives us noise values that change smoothly over
        //         time
        //     ofSignedNoise(time*timeScale) allows us to control the smoothness of
        //         our noise (smaller timeScale, smoother values)
        //     ofSignedNoise(time+timeOffset) allows us to use the same Perlin noise
        //         function to control multiple things and have them look as if they
        //         are moving independently
        //     ofSignedNoise(time)*displacementScale allows us to change the bounds
        //         of the noise from [-1, 1] to whatever we want
        // Combine all of those parameters together, and you've got some nice
        // control over your noise

        vert.x += (ofSignedNoise(time*timeScale+timeOffsets.x)) * displacementScale;
        vert.y += (ofSignedNoise(time*timeScale+timeOffsets.y)) * displacementScale;
        vert.z += (ofSignedNoise(time*timeScale+timeOffsets.z)) * displacementScale;
        mesh.setVertex(i, vert);
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofColor centerColor = ofColor(85, 78, 68);
    ofColor edgeColor(0, 0, 0);
    ofBackgroundGradient(centerColor, edgeColor, OF_GRADIENT_CIRCULAR);
    
    gui.draw();

    // ofSetColor(ofColor("green"));
    // ofCircle(camX, camY, camZ, 10);


    
    easyCam.begin();
        ofPushMatrix();
            
            ofTranslate(-ofGetWidth()/2, ofGetHeight()/2);
            ofRotateDeg(180, 0, 0, 1);
            ofRotateDeg(180, 0, 1, 0);

            //TODO: move to separate function
            int axis_len(100);
            ofPoint O(0, 0, 0), OX(axis_len, 0, 0), OY(0, axis_len, 0), OZ(0, 0, axis_len);
            ofSetLineWidth(10);

            ofSetColor(ofColor::red);
            ofDrawLine(O, OX);

            ofSetColor(ofColor::green);
            ofDrawLine(O, OY);

            ofSetColor(ofColor::blue);
            ofDrawLine(O, OZ);

            ofSetLineWidth(1);
            mesh.draw();
        ofPopMatrix();        
    easyCam.end();
    cout << "cam distance: " << easyCam.getDistance() << "\n";
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){
    cout << "X: " << easyCam.getX() << " Y: " << easyCam.getY() << " Z: " << easyCam.getZ() << "\n";
}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}