import Html exposing (Html, button, div, text, input, ul, li)
import Html.App as App
import Html.Events exposing (onClick, onInput)
import Html.Attributes as Attr
import String


main =
  App.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type Visibility = All | Active | Completed

type alias Task = { content: String, complete: Bool, id: Int }


type alias Model =
  {
    tasks : List Task,
    visibility : Visibility,
    inputText: String,
    nowId: Int
}

model : Model
model =
  {
  tasks = [],
  visibility = All,
  inputText = "",
  nowId = 0
  }


-- UPDATE

type Msg
  = Add
  | ChangeVisibility Visibility
  | ChangeInputText String
  | ToggleTask Int

update : Msg -> Model -> Model
update msg model =
  case msg of
    Add ->
      { model | tasks =
        if String.length model.inputText /= 0  then
          model.tasks ++ [Task model.inputText False model.nowId]
        else
          model.tasks
        , nowId = model.nowId + 1
      }

    ChangeVisibility visibility ->
      { model | visibility = visibility }

    ChangeInputText text ->
      { model | inputText = text }

    ToggleTask id ->
      { model | tasks = List.map (\task -> if task.id == id then { task | complete = task.complete == False } else task ) model.tasks }

-- VIEW

todosView : List Task -> List (Html Msg)
todosView tasks = List.map (\task -> li [ onClick (ToggleTask task.id) ] [ text (toString task.complete ++ " " ++ task.content) ]) tasks

-- onEnter msg : Msg -> Attribute Msg
-- onEnter msg =
--   let
--     tagger code =
--       if code == 13 then msg else

view : Model -> Html Msg
view model =
  div []
    [ input [ Attr.type' "text", Attr.placeholder "task", onInput ChangeInputText  ] [ ]
    , button [ onClick Add ] [ text "Add" ]
    , ul [] (todosView model.tasks)
    ]
