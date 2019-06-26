#include "ofMain.h"
#include "ofApp.h"

//========================================================================
int main( ){
    ofSetupOpenGL(500,500,OF_WINDOW);			// <-------- setup the GL context
    ofSetWindowPosition(ofGetScreenWidth()/2, ofGetScreenHeight()/2);

    // this kicks off the running of my app
    // can be OF_WINDOW or OF_FULLSCREEN
    // pass in width and height too:
    ofRunApp(new ofApp());

}
