import Html exposing (Html, button, div, text, input, ul, li)
import Html.App as Html
import Html.Events exposing (onClick)
import Html.Attributes as Attr


main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type Visibility = All | Active | Completed

type alias Task = { content: String, complete: Bool }

type alias Model =
  {
    tasks : List Task,
    visibility : Visibility
}

model : Model
model =
  {
  tasks = [],
  visibility = All
  }


-- UPDATE

type Msg
  = Add String
  | ChangeVisibility Visibility

update : Msg -> Model -> Model
update msg model =
  case msg of
    Add taskText ->
      { model | tasks = model.tasks ++ [Task taskText True] }

    ChangeVisibility visibility ->
      { model | visibility = visibility }


-- VIEW

todosView : List Task -> List (Html Msg)
todosView tasks = List.map (\task -> li [] [ text task.content ]) tasks

view : Model -> Html Msg
view model =
  div []
    [ input [ Attr.type' "text", Attr.placeholder "task" ] [ ]
    , button [ onClick (Add "test") ] [ text "Add" ]
    , ul [] (todosView model.tasks)
    ]
