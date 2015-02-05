Elemento de una escena (por ejemplo, un animal con distintas partes animadas)

Se defienen:

Layers individuales
Animaciones individuales
Grupos de animaciones formados por las animaciones individuales
Acciones:
          Acciones sobre el elemento que animan distintos layers o todos los layers
            - tap
            - double-tap
            - swipe-left
            - swipe-right
            - in_time : Este es un id propio que define a partir de qué segundo se ejecuta la animación

            __all_layers_composition__ : Se refiere a que afecta a todas las layers de la composición



Posibles valores en las animaciones:

 - "keyPath" : Puede ser -> transform.rotation.x
                            transform.rotation.y
                            transform.rotation.z
                            transform.rotation (es el z por defecto) 

                            transform.scale.x
                            transform.scale.y
                            transform.scale.z
                            transform.scale  (sería x,y,z por defecto)

                            transform.translation.x
                            transform.translation.y
                            transform.translation.z
                            transform.translation (por defecto en x,y necesita un NSSize)

                            opacity


Posibles valores de fromValue y de toValue:

                            Integer
                            double
                            CGRect
                            CGPoint
                            CGSize
                            CATransform3D



Pendiente: 

          Página
          Sonido princial de la página
          Siguiente
          Opciones de siguiente (elige tu propia aventura)

          


{
  "bounds": [0, 0, 200, 200],
  "position": [0, 0],
  "opacity" : 0.5,
  "anchorPoint" : [0, 0.5],
  "image" : "/relative/url/to/picture.png",
  "layers" : {
               "layer-pata-izquierda" : {
                                    "bounds" : [0, 0, 50, 50],
                                    "position" : [10, 10],
                                    "opacity" : 0.3,
                                    "anchorPoint" : [0, 0.5],
                                    "image" : "/relative/url/to/picture1.png",
                                    "sublayerTransform" : {"name" : "CATransform3DMakePerspective", "value" : "1000"}
                                  },
                "layer-pata-derecha" :  {
                                    "bounds" : [0, 0, 50, 50],
                                    "position" : [60, 60],
                                    "opacity" : 0.7,
                                    "anchorPoint" : [0, 0.5],
                                    "image" : "/relative/url/to/picture2.png"
                                  } 

             },

  "animations" : {
                    "animation_name_1" : {
                                            "keyPath" : "transform",
                                            "fromValue" : {
                                                            "type" : "3d",
                                                            "subtype" : "3DIdentity"
                                                          },
                                            "toValue" : {
                                                            "type" : "3d",
                                                            "subtype" : "3DMakeRotation",
                                                            "value" : [85, 0, 1, 0]
                                                          },
                                            "duration" : "10",
                                            "autoreverses" : "YES",
                                            "repeatCount" : "INFINITY",
                                            "timingFunction" : "EaseInEaseOut",
                                            "fillMode" : "kCAFillModeForwards",
                                            "removedOnCompletion" : "NO"
                                         },
                    "animation_name_2" : {
                                            "fromValue" : {
                                                            "type" : "size",
                                                            "value" : [100, 40]
                                                          },
                                            "toValue" : {
                                                          "type" : "number",
                                                          "value" : [4.5]
                                                        }
                                            
                                         }
                 },

  "group_animations" : {
                         "group_name_1" : {
                                             "options_group" : {
                                                                 "dato_1" : "",
                                                                 "dato_2" : "",
                                                                 "dato_n" : ""
                                                               },
                                              "animations" : ["animation_name_1", "animation_name_5"]
                                          },

                          "group_name_2" : {
                                              "options_group" : {
                                                                  "dato_1" : "",
                                                                  "dato_2" : "",
                                                                  "dato_n" : ""
                                                                },
                                              "animations" : ["animation_name_1", "animation_name_2"]
                                            }

                        },

  "actions" : {
                "tap" :
                [ //Array de animaciones secuenciales (UNA DETRÁS DE OTRA)

                    {
                      "duration": 121,
                      "transforms":
                            [ //Las aniamciones de este ARRAY es simultaneo (TODAS A LA VEZ)

                                { "layer": "id_layer1", "anims" : ["animation_name_1", "animation_name_2"], //animaciones para cada layer
                                { "layer": "id_layer2", "prop1": val1, "prop2", val2}

                            ]
                    },
                    {
                      "duration": 121,
                      "transforms":
                            [
                                { "layer": "id_layer1", "prop1": val1, "prop2", val2},
                                { "layer": "id_layer2", "prop1": val1, "prop2", val2}
                            ]
                    }

                  {
                    "layer_id" : "layer-pata-izquierda", 
                    "animation_group_id" : "group_name_2", 
                    "animation_simple" : "animation_name_1" 
                  }, 
                          {
                            "layer_id" : "__all_layers_composition__", 
                            "animation_group_id" : "group_name_1", 
                            "animation_simple" : "" 
                          }
                        ],

                "double-tap" : [
                          {
                            "layer_id" : "layer-pata-izquierda", 
                            "animation_group_id" : "group_name_2", 
                            "animation_simple" : "animation_name_1" 
                          }, 
                          {
                            "layer_id" : "__all_layers_composition__", 
                            "animation_group_id" : "group_name_1", 
                            "animation_simple" : "" 
                          }
                        ],
                "swipe-left" : [
                          {
                            "layer_id" : "layer-pata-izquierda", 
                            "animation_group_id" : "group_name_2", 
                            "animation_simple" : "animation_name_1" 
                          }, 
                          {
                            "layer_id" : "__all_layers_composition__", 
                            "animation_group_id" : "group_name_1", 
                            "animation_simple" : "" 
                          }
                        ],
                "in_time" : [
                          {
                            "layer_id" : "layer-pata-derecha", 
                            "animation_group_id" : "group_name_2", 
                            "animation_simple" : "animation_name_1",
                            "start_time" : 500 
                          }, 
                          {
                            "layer_id" : "__all_layers_composition__", 
                            "animation_group_id" : "group_name_1", 
                            "animation_simple" : "",
                            "start_time" : 0 
                          }
                        ]

              }

  
}