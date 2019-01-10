(define (domain logistics)
(:requirements :durative-actions :typing :fluents)

(:types lorry driver heavy-package, light-package, crane - object)

(:predicates (at ?x - (either driver lorry light-package heavy-package) ?city - city)
                (crane-working  ?city - city)
                (road ?city1 - city ?city2 - city)
                (empty ?lorry - lorry)
             (inside ?x - (either driver heavy-package
         light-package
        ) ?lorry - lorry))

(:functions 
            (cost ?city1 - city ?city2 - city)
            (time ?city1 - city ?city2 - city)

            (load-time-light)
            (unload-time-light)

            (load-time-heavy)
            (unload-time-heavy)

            (load-cost-light)
            (unload-cost-light)

            (load-cost-heavy)
            (unload-cost-heavy)

            (get-in-cost)
            (get-of-cost)
            (get-in-time)
            (get-of-time)

            (bus-cost)
            (bus-time)
            
            (total-cost)
            )


(:durative-action get-in
 :parameters (?driver ?other_driver - driver ?lorry - lorry ?city - city)
 :duration (= ?duration (get-in-time))
 :condition (and (at start (at ?driver ?city))
                (at start (empty ?lorry))
                (at end (at ?lorry ?city))
                (at start (at ?lorry ?city))
                 (over all (at ?lorry ?city)))
 :effect (and (at start (not (at ?driver ?city)))
              (at end (inside ?driver ?lorry))
              (at start (not (empty ?lorry)))
               (at end (increase (total-cost) (get-in-cost)))
              ))

(:durative-action get-of
 :parameters (?driver - driver ?lorry - lorry ?city - city)
 :duration (= ?duration (get-of-time))
 :condition (and (at start (inside ?driver ?lorry))
                (at end (at ?lorry ?city))
                (at start (at ?lorry ?city))
                 (over all (at ?lorry ?city)))
 :effect (and (at start (not (inside ?driver ?lorry)))
              (at end (empty ?lorry))
               (at end (increase (total-cost) (get-of-cost)))
              (at end (at ?driver ?city))))

(:durative-action drive 
 :parameters (?lorry - lorry ?city1 ?city2 - city ?driver - driver)
 :duration (= ?duration (time ?city1 ?city2))
 :condition (and (at start (at ?lorry ?city1))
                  (at start (road ?city1 ?city2))
                 (at start (inside ?driver ?lorry) ))
 :effect (and (at start (not (at ?lorry ?city1)))
               (at end (increase (total-cost) (cost ?city1 ?city2)))
              (at end (at ?lorry ?city2)))) 
                                  

(:durative-action bus-travel 
 :parameters (?city1 ?city2 - city ?driver - driver)
 :duration (= ?duration (bus-time))
 :condition (and (at start (at ?driver ?city1))
                  (at start (road ?city1 ?city2))
 )
 :effect (and (at start (not (at ?driver ?city1)))
              (at end (at ?driver ?city2))
               (at end (increase (total-cost) (bus-cost)))
              ))

(:durative-action load_light
 :parameters (?package - light-package ?city - city ?lorry - lorry)
 :duration (= ?duration (load-time-light))
 :condition (and (at start (at ?package ?city))
                (at start (at ?lorry ?city))
                (at end (at ?lorry ?city))
                 (over all (at ?lorry ?city)))
 :effect (and (at start (not (at ?package ?city)))
                (at end (increase (total-cost) (load-cost-light)))
                (at end (at ?lorry ?city))
              (at end (inside ?package ?lorry))))


(:durative-action unload_light
 :parameters (?package - light-package ?city - city ?lorry - lorry)
 :duration (= ?duration (unload-time-light))
 :condition (and (at start (at ?lorry ?city))
                (at start (inside ?package ?lorry))
                 (over all (at ?lorry ?city))
                 (at end (at ?lorry ?city))
                 )
 :effect (and (at start (not (inside ?package ?lorry)))
                (at end (increase (total-cost) (load-cost-light)))
              (at end (at ?package ?city))))

(:durative-action load_heavy
 :parameters (?package - heavy-package ?city - city ?lorry - lorry)
 :duration (= ?duration (load-time-heavy))
 :condition (and (at start (at ?package ?city))
                (at start (not (crane-working ?city)))
                (at start (at ?lorry ?city))
                (at end (at ?lorry ?city))
                 (over all (at ?lorry ?city)))
 :effect (and (at start (not (at ?package ?city)))
                (at end (increase (total-cost) (load-cost-heavy)))
                (at end (at ?lorry ?city))
                (at start (crane-working ?city))
                (at end (not (crane-working ?city)))
              (at end (inside ?package ?lorry))
              ))

(:durative-action unload_light
 :parameters (?package - heavy-package ?city - city ?lorry - lorry)
 :duration (= ?duration (unload-time-heavy))
 :condition (and (at start (at ?lorry ?city))
                (at start (inside ?package ?lorry))
                (at start (not (crane-working ?city)))
                (over all (at ?lorry ?city))
                 (at end (at ?lorry ?city))
                 )
 :effect (and (at start (not (inside ?package ?lorry)))
                (at end (increase (total-cost) (load-cost-heavy)))
                 (at start (crane-working ?city))
                (at end (not (crane-working ?city)))
              (at end (at ?package ?city)))
                                
)

)