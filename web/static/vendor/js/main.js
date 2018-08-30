
// once everything is loaded, we run our Three.js stuff.



    // create a scene, that will hold all our elements such as objects, cameras and lights.
    var scene = new THREE.Scene();
    var mouse = new THREE.Vector2();
    var mouseX = 0, mouseY = 0;
    var windowHalfX = window.innerWidth / 2;
		var windowHalfY = window.innerHeight / 2;
    document.addEventListener('mousemove', onDocumentMouseMove, false);
    //scene.background = new THREE.Color( 0x000000 );



    // create a camera, which defines where we're looking at.
    var camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
    //camera = new THREE.PerspectiveCamera( 55, window.innerWidth / window.innerHeight, 2, 2000 );

    // create a render and set the size
    var webGLRenderer = new THREE.WebGLRenderer({ alpha: true });
    //webGLRenderer.setClearColor(new THREE.Color(0x000000, 1.0));
    webGLRenderer.setSize(window.innerWidth, window.innerHeight);
    webGLRenderer.shadowMap.enabled = true;
    webGLRenderer.setClearColor( 0x000000, 0);


    // position and point the camera to the center of the scene
    camera.position.x = -30;
    camera.position.y = 40;
    camera.position.z = 50;
    camera.lookAt(new THREE.Vector3(10, 0, 0));

    // add the output of the renderer to the html element
    $("#target").append(webGLRenderer.domElement);

    // call the render function
    var step = 0;
    var step2 = 0;

    var knot;



    // setup the control gui
    var controls = new function () {
        // we need the first child, since it's a multimaterial
        this.radius = 1;
        this.tube = 28.2;
        this.radialSegments = 100;
        this.tubularSegments = 7;
        this.p = 5;
        this.q = 4;
        this.heightScale = 4;
        this.asParticles = true;
        this.rotate = true;

        this.redraw = function () {
            // remove the old plane
            if (knot) scene.remove(knot);
            // create a new one
            var geom = new THREE.TorusKnotGeometry(controls.radius, controls.tube, Math.round(controls.radialSegments), Math.round(controls.tubularSegments), Math.round(controls.p), Math.round(controls.q), controls.heightScale);

            if (controls.asParticles) {
                knot = createParticleSystem(geom);
            } else {
                knot = createMesh(geom);
            }

            // add it to the scene.
            scene.add(knot);

        };

    }


    controls.redraw();

    render();

    // from THREE.js examples
    function generateSprite() {

        var canvas = document.createElement('canvas');
        canvas.width = 16;
        canvas.height = 16;

        var context = canvas.getContext('2d');
        var gradient = context.createRadialGradient(canvas.width / 2, canvas.height / 2, 0, canvas.width / 2, canvas.height / 2, canvas.width / 2);
        gradient.addColorStop(0, 'rgba(255,255,255,1)');
        gradient.addColorStop(0.2, 'rgba(255,255,255,1)');
        gradient.addColorStop(0.4, 'rgba(0,0,64,1)');
        gradient.addColorStop(1, 'rgba(0,0,0,1)');

        context.fillStyle = gradient;
        context.fillRect(0, 0, canvas.width, canvas.height);

        var texture = new THREE.Texture(canvas);
        texture.needsUpdate = true;
        return texture;

    }

    function createParticleSystem(geom) {
        var material = new THREE.PointsMaterial({
            color: 0xf9ee74,
            size: 3,
            transparent: true,
            blending: THREE.AdditiveBlending,
            map: generateSprite()
        });

        var system = new THREE.Points(geom, material);
        system.sortParticles = true;
        return system;
    }

    function createMesh(geom) {

        // assign two materials
        var meshMaterial = new THREE.MeshNormalMaterial({});
        meshMaterial.side = THREE.DoubleSide;

        // create a multimaterial
        var mesh = THREE.SceneUtils.createMultiMaterialObject(geom, [meshMaterial]);

        return mesh;
    }

    function onDocumentMouseMove(event) {
      event.preventDefault();
    mouseX = event.clientX - windowHalfX;
		mouseY = event.clientY - windowHalfY;
      console.log(mouse);
    }

    function render() {
      //var posx = mouse.x = ( event.clientX / window.innerWidth ) * 2 - 1;
      //var posy = mouse.y = - ( event.clientY / window.innerHeight ) * 2 + 1;
      //camera.position.x += ( mouseX - camera.position.x ) * 0.001;
			//camera.position.y += ( - mouseY - camera.position.y ) * 0.001;
      //camera.position.z = 50;
			//camera.lookAt( scene.position );
        if (controls.rotate) {
            //knot.rotation.y = step += 0.0001;
            knot.rotation.y = step += (mouseX * 0.00001);
            knot.rotation.x = step2 += (mouseY * 0.00001);
        }

        // render using requestAnimationFrame
        requestAnimationFrame(render);
        webGLRenderer.render(scene, camera);
    }
