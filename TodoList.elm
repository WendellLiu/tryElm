import Html exposing (Html, button, div, span, text, input, ul, li)
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
  | ClearAll
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
        , inputText = ""
      }

    ClearAll ->
      { model | tasks = [] }

    ChangeVisibility visibility ->
      { model | visibility = visibility }

    ChangeInputText text ->
      { model | inputText = text }

    ToggleTask id ->
      { model |
        tasks = List.map
          (\task -> if task.id == id
            then { task | complete = task.complete == False }
            else task )
          model.tasks
      }

-- VIEW

todosView : Visibility -> List Task -> List (Html Msg)
todosView visibility tasks =
  let
    filterTasks =
      case visibility of
        All ->
          tasks
        Completed ->
          List.filter
          (\task -> task.complete == True)
          tasks
        Active ->
          List.filter
          (\task -> task.complete == False)
          tasks
  in
    List.map
    (\task -> li [ onClick (ToggleTask task.id) ] [ text (toString task.complete ++ " " ++ task.content) ])
    filterTasks

-- onEnter msg : Msg -> Attribute Msg
-- onEnter msg =
--   let
--     tagger code =
--       if code == 13 then msg else

view : Model -> Html Msg
view model =
  div []
    [ input [ Attr.type' "text", Attr.placeholder "task", onInput ChangeInputText, Attr.value model.inputText  ] [ ]
    , button [ onClick Add ] [ text "Add" ]
    , button [ onClick ClearAll ] [ text "Clear All" ]
    , filterNav
    , ul [] (todosView model.visibility model.tasks)
    ]

nav : Visibility -> Html Msg
nav visibility =
  div [ onClick (ChangeVisibility visibility) ] [ text (toString visibility) ]

filterNav : Html Msg
filterNav =
  div []
    [
      nav All,
      nav Active,
      nav Completed
    ]
