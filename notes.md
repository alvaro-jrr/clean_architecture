# Clean Architecture

-   Cada feature de la app, como `GetNumberTrivia`, se dividirá en tres partes: Presentation, Domain y Data.

-   Un feature puede ser un number trivia, un login, registration, settings.

-   No es suficiente solo tener `features`, porque hay cosas que pueden ser utilizadas por diferentes features. Este tipo de funcionalidades se debe almacenar en la carpeta `core`.

## Presentation

Está conformada por widgets, pages, los custom widgets y además, contiene los presentation logic handlers (manejadores de estado como Bloc, ChangeNotifier, etc). Los presentation logic handlers delegan su trabajo a los layers superficiales, como el Domain.

Bloc o ChangeNotifier solo serán clean classes, no tendran mucha lógica y como mucho tendrá una validación básica del input. Lo demás será delegado a los use cases (Domain layer).

## Domain

Este layer que no deberia ser susceptible a los cambios de data sources o llevando nuestra app a Angular o Dart, debe ser independendiente de la plataforma e independiente de cualquier cosa dentro de la app. Solo contendrá la lógica principal de negocio, que será ejecutada en `Use Cases` y modelos de negocio que serán llamados `Entities`.

Los `Use Cases` son clases que encapsulan toda la lógica de negocio de un caso de uso particular de la app. Por ejemplo, un caso de uso es `GetConcreteNumberTrivia` y otro `GetRandomTrivia`, entonces habrían 2 clases.

La clase `Repository` esta en el borde entre `Data` y `Domain`. Para ello, creamos una clase abstracta `Repository` que define un contrato sobre el `Repository` debe hacer.

Por ejemplo, en nuestra app debemos tener un `Repository` que debe proveernos de random trivia y concrete number trivia. Esas son las dos cosas que el `Repository` debe hacer y eso va en el `Domain` layer.

El `Domain` layer no le interesa cómo el number trivia se obtenga, solo se asegura que se obtenga.

## Data

Este layer definirá como se obtendrá y se manejará la data. El `Repository` en esta capa implementará al clase abstracta que debe completar el contrato que defina el `Domain` layer, de tal forma que al `Domain` no le interese que pasa detrás de escena, solo sabe que tipo de data siempre recibirá.

Además, este almacenará cualquier tipo de data source, ya sea remoto (apis) o local (base de datos o almacenamiento local de la plataforma).

El `Repository` debe saber cuando obtener data remota o local. Por ejemplo, si no hay internet debe buscar la data localmente.

Los data sources no tendrán como salida los `Entities` del `Domain` layer. Estos lidian con algo llamado `Models`, los cuales transforman raw data (como JSON), ya que estos requieren una lógica de conversión, puesto que las apps no trabajan con JSON, debemos trabajar con Dart objects. Esta lógica de conversión (como `fromJSON`) no se debe poner en los `Entities`, porque deben ser completamente independientes de la plataforma, a este no le debe interesar si la data source es binario, JSON o XML, esto no debe cambiar el `Domain` layer.

Entonces, los `Models` son clases que extienden los `Entities` y agregan funcionalidades por encima de ellos y como son subclases de los `Entities`, se pueden castear a `Entities` y el `Repository` como salida tendrá los `Entities` sin ningun campo o funcionalidad encima de ellos.

Los `Models` pueden tener más campos, por ejemplo, si se debe almacenar el `id`. Este se puede almacenar `Models`.

Los remote data sources ejecutarán peticiones http a las APIs para obtener la data. Mientras que los local data sources obtendrán los datos de la db local o shared preferences. Finalmente, estos se combinarán en el `Repository`.

## Tests con Fixtures

Un fixture es es un archivo que almacena al respuesta que debe recibir de un data source. La data en los fixtures puede contener valores de testing, pero debe tener todos los campos y seguir la estructura de la respuesta.
