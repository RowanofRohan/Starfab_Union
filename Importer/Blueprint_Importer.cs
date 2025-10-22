#if UNITY_EDITOR

using System.IO;
using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System;
using UnityEditor.Search;
using Newtonsoft.Json;
using System.Linq;
using Newtonsoft.Json.Linq;
using Unity.Burst.Intrinsics;
using System.Runtime.InteropServices;
using UnityEngine.UIElements;
using VRC.Core.Pool;
using BestHTTP.SecureProtocol.Org.BouncyCastle.Asn1.X509;
using UnityEngine.InputSystem.EnhancedTouch;
using Mono.CompilerServices.SymbolWriter;
using VRC.Udon.Editor.ProgramSources.UdonGraphProgram.UI;
using VRC;
using Cysharp.Threading.Tasks;
using AmplifyShaderEditor;
using System.Linq.Expressions;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Xml;
using UnityEditor.Experimental.GraphView;
using System.Xml.Linq;
using BestHTTP.JSON;
using UnityEditor.VersionControl;
using Unity.Burst.CompilerServices;
using TMPro;
using UnityEditor.Profiling.Memory.Experimental;
using UnityEngine.Analytics;
using UnityEngine.Scripting;

public class SCBPImporter : EditorWindow
{

    #region Vars
    SCBPImporterConfig config = new SCBPImporterConfig();
    LightImportSettings lightImportSettings = new LightImportSettings();
    GlobalImportSettings globalImportSettings = new GlobalImportSettings();
    UnityEngine.Object blueprintSource = null;

    UnityEngine.Object prefabSource = null;

    string configSaveLocation = "Assets/Starfab/Importer/Config.Json";

    Dictionary<string, LightContainerReference> availableLights;
    List<GameObject> foundLights = new List<GameObject>();

    //Dictionary<string, SubMat> availableMaterials;
    MaterialDefinitions availableMaterials;
    List<string> foundMaterials = new List<string>();

    //int lightsFound = 0;
    //int materialsFound = 0;

    //ShaderList projectShaders; // = new ShaderList();

    Material srcMat;
    Material destMat;

    #endregion

    #region Internal Classes

    public class SingleValueArrayConverter<T> : JsonConverter
    {
        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            //throw new NotImplementedException();
            var list = value as IList<T>;

            serializer.Serialize(writer, list);
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            object retVal = new object();
            if (reader.TokenType == JsonToken.StartObject)
            {
                T instance = (T)serializer.Deserialize(reader, typeof(T));
                retVal = new List<T>() { instance };
            }
            else if (reader.TokenType == JsonToken.StartArray)
            {
                retVal = serializer.Deserialize(reader, objectType);
            }
            return retVal;
        }

        public override bool CanConvert(Type objectType)
        {
            return true;
        }

    }

    public class ShaderList
    {
        public Shader illumShader;
        public Shader shadowlessShader;
        public Shader decalShader;
        public Shader emitShader;
        public Shader pomShader;
        public Shader hardSurfaceShader;
        public Shader layerBlendShader;
        public Shader displayScreenShader;
        public Shader glassShader;
    }

    [Serializable]
    public class SCBPImporterConfig
    {
        public UnityEngine.Object blueprintSource { get; set; }
        public GlobalImportSettings globalSettings { get; set; }
        public LightImportSettings lightImportSettings { get; set; }
    }


    [Serializable]
    public class GlobalImportSettings
    {
        public bpContainer importedBlueprint { get; set; }
        public bool preferTIF { get; set; }
        public bool overwriteTextures { get; set; }
        public bool overwriteMaterials { get; set; }
        public GameObject targetObject { get; set; }

        public string assetSources { get; set; }
        public string assetDestination { get; set; }

        public string materialGenerationPath { get; set; }
        public string prefabGenerationPath { get; set; }

        public string configFilePath { get; set; }

        //[SerializeField]
        //string prefabSourcePath { get; set; }

        public GlobalImportSettings()
        {
            importedBlueprint = null;
            preferTIF = true;
            targetObject = null;
            overwriteTextures = false;
            overwriteMaterials = false;
            assetSources = "";
            assetDestination = "Assets/Starfab_Union/Imported_Files/Data";
            materialGenerationPath = "Assets/Starfab_Union/Generated_Materials";
            prefabGenerationPath = "Assets/Starfab_Union/Generated_Prefabs";
            configFilePath = "Assets/Starfab_Union/Config";
        }
    }


    [Serializable]
    public class LightContainerReference
    {

        public string socPath { get; set; }
        public string lightGroupName { get; set; }
        public string lightName { get; set; }
        public SocLightContainer lightContainer { get; set; }
    }

    [Serializable]
    public class MaterialReference
    {
        public string assetPath { get; set; }
        public List<string> subMaterials { get; set; }

    }

    [Serializable]
    public class MatTextureReference
    {
        //public int textureSlot { get; set; }
        public string texturePath { get; set; }
        public Vector2 textureTiling {get; set;}
    }

    [Serializable]
    public class MaterialDefinitions
    {
        public Dictionary<string, SubMat> blueprintMaterials { get; set; }
        public Dictionary<string, SubMat> loadedMaterials { get; set; }
        public Dictionary<string, SubMat> loadedLayers { get; set; }
    }


    public enum LightStateName
    {
        Default,
        Auxilary,
        Emergency,
        Cinematic
    }

    [Serializable]
    public class LightImportSettings
    {
        public bool fixTransforms { get; set; }
        public bool useGamma { get; set; }
        public bool simulatePhysical { get; set; }
        public bool findCookies { get; set; }
        public float gammaScale { get; set; }
        public float rangeMulti { get; set; }
        public float intensityMulti { get; set; }
        public LightStateName state { get; set; }


        public LightImportSettings()
        {
            fixTransforms = false;
            useGamma = true;
            simulatePhysical = false;
            findCookies = true;
            gammaScale = 1.0f;
            rangeMulti = 1.0f;
            intensityMulti = 1.0f;
            state = LightStateName.Default;
        }
    }
    #endregion

    #region Blueprint JSON Definition

    [Serializable]
    public class bpContainer
    {
        public string name { get; set; }
        public string entity_geom { get; set; }
        public Dictionary<string, socContainer> socs { get; set; }
        public Dictionary<string, string> asset_info { get; set; }
        public string[] bone_names { get; set; }
        public Dictionary<string, hardPoint> hardpoints { get; set; }
        public Dictionary<string, GeometryInstance> geometry { get; set; }
        public string[] tint_palettes { get; set; }
        public Dictionary<string, ContainerInstance> containers { get; set; }
    }

    [Serializable]
    public class socContainer
    {
        //string json = @"{""key1"":""value1"",""key2"":""value2""}";
        //var values = JsonConvert.DeserializeObject<Dictionary<string, string>>(json);
        public Dictionary<string, Dictionary<string, SocInstanceContainer>> instances { get; set; }
        public Dictionary<string, Dictionary<string, SocLightContainer>> lights { get; set; }
    }

    [Serializable]
    public class SocInstanceContainer
    {
        public XYZVector pos { get; set; }
        public JToken rotation { get; set; }
        public XYZVector scale { get; set; }
        public string[] materials { get; set; }
        public Dictionary<string, string> attrs { get; set; }
    }

    [Serializable]
    public class SocLightContainer
    {
        public Dictionary<string, string> BaseProperties { get; set; }

        public EntityComponentLight EntityComponentLight { get; set; }
        public LightAudioContainer LightAudioComponent { get; set; }
        public LightXForm RelativeXForm { get; set; }
        [JsonProperty(PropertyName = "@EntityCryGUID")]
        public string EntityCryGUID { get; set; }
        [JsonProperty(PropertyName = "@Pos")]
        public string Pos { get; set; }
        [JsonProperty(PropertyName = "@Rotate")]
        public string Rotate { get; set; }
        public Dictionary<string, string> attrs { get; set; }
    }

    [Serializable]
    public class EntityComponentLight
    {
        public LightSizeParams sizeParams { get; set; }
        public Dictionary<string, string> offState { get; set; }
        public LightState defaultState { get; set; }
        public LightState auxilaryState { get; set; }
        public LightState emergencyState { get; set; }
        public LightState cinematicState { get; set; }
        public Dictionary<string, string> projectorParams { get; set; }
        public Dictionary<string, string> shadowParams { get; set; }
        public Dictionary<string, string> styleParams { get; set; }
        public Dictionary<string, string> groupParams { get; set; }
        public Dictionary<string, string> clipBoxParams { get; set; }
        public Dictionary<string, string> fadeParams { get; set; }
        public Dictionary<string, string> miscParams { get; set; }
        public Dictionary<string, string> flareParams { get; set; }
        [JsonProperty(PropertyName = "@__type")]
        public string __type { get; set; }
        [JsonProperty(PropertyName = "@active")]
        public int active { get; set; }
        [JsonProperty(PropertyName = "@lightType")]
        public string lightType { get; set; }
        [JsonProperty(PropertyName = "@importance")]
        public string importance { get; set; }
        [JsonProperty(PropertyName = "@affectsThisAreaOnly")]
        public int affectsThisAreaOnly { get; set; }
        [JsonProperty(PropertyName = "@affectsFog")]
        public int affectsFog { get; set; }
        [JsonProperty(PropertyName = "@affectsObjects")]
        public int affectsObjects { get; set; }
        [JsonProperty(PropertyName = "@useTemperature")]
        public int useTemperature { get; set; }
        [JsonProperty(PropertyName = "@distantImposter")]
        public int distantImposter { get; set; }
        [JsonProperty(PropertyName = "@ignoreLightFlickerEntities")]
        public int ignoreLightFlickerEntities { get; set; }
        [JsonProperty(PropertyName = "@affectGI")]
        public string affectGI { get; set; }
        [JsonProperty(PropertyName = "@enabledWithGI")]
        public string enabledWithGI { get; set; }
        public Dictionary<string, Dictionary<string, string>> GeomLinks { get; set; }
    }

    [Serializable]
    public class LightSizeParams
    {
        [JsonProperty(PropertyName = "@__type")]
        public string __type { get; set; }
        [JsonProperty(PropertyName = "@lightRadius")]
        public float lightRadius { get; set; }
        [JsonProperty(PropertyName = "@bulbRadius")]
        public float bulbRadius { get; set; }
        [JsonProperty(PropertyName = "@planeWidth")]
        public float planeWidth { get; set; }
        [JsonProperty(PropertyName = "@planeHeight")]
        public float planeHeight { get; set; }

    }

    [Serializable]
    public class LightState
    {
        public LightStateColor color { get; set; }
        [JsonProperty(PropertyName = "@__type")]
        public string __type { get; set; }
        [JsonProperty(PropertyName = "@intensity")]
        public float intensity { get; set; }
        [JsonProperty(PropertyName = "@presetTag")]
        public string presetTag { get; set; }
        [JsonProperty(PropertyName = "lightStyle")]
        public string lightStyle { get; set; }
        [JsonProperty(PropertyName = "@temperature")]
        public float temperature { get; set; }
    }

    [Serializable]
    public class LightStateColor
    {
        [JsonProperty(PropertyName = "@__type")]
        public string __type { get; set; }
        [JsonProperty(PropertyName = "@r")]
        public float r { get; set; }
        [JsonProperty(PropertyName = "@g")]
        public float g { get; set; }
        [JsonProperty(PropertyName = "@b")]
        public float b { get; set; }
    }

    [Serializable]
    public class LightAudioContainer
    {
        public LightAudioTrigger playTrigger { get; set; }
        public LightAudioTrigger stopTrigger { get; set; }
        public LightAudioTrigger lightGroupStateDefaultPlayTrigger { get; set; }
        public LightAudioTrigger lightGroupStateDefaultStopTrigger { get; set; }
        public LightAudioTrigger lightGroupStateAuxilaryPlayTrigger { get; set; }
        public LightAudioTrigger lightGroupStateAuxilaryStopTrigger { get; set; }
        public LightAudioTrigger lightGroupStateEmergencyPlayTrigger { get; set; }
        public LightAudioTrigger lightGroupStateEmergencyStopTrigger { get; set; }
        public LightAudioTrigger lightGroupStateCinematicPlayTrigger { get; set; }
        public LightAudioTrigger lightGroupStateCinematicStopTrigger { get; set; }
        public Dictionary<string, string> luminanceRtpc { get; set; }
        [JsonProperty(PropertyName = "@__type")]
        public string __type { get; set; }
        [JsonProperty(PropertyName = "@enableAudio")]
        public string enableAudio { get; set; }
        [JsonProperty(PropertyName = "@attenuationScale")]
        public string attenuationScale { get; set; }
        [JsonProperty(PropertyName = "@volume_db")]
        public string volume_db { get; set; }
    }

    [Serializable]
    public class LightAudioTrigger
    {
        [JsonProperty(PropertyName = "@__type")]
        public string __type { get; set; }
        [JsonProperty(PropertyName = "@audioTrigger")]
        public string audioTrigger { get; set; }
    }

    [Serializable]
    public class LightXForm
    {
        [JsonProperty(PropertyName = "@rotation")]
        public string rotation { get; set; }
        [JsonProperty(PropertyName = "@translation")]
        public string translation { get; set; }

    }

    [Serializable]
    public class hardPoint
    {
        public string[] geometry { get; set; }
        public Dictionary<string, GeometryLoadoutReference> loadout { get; set; }

    }

    [Serializable]
    public class GeometryInstance
    {
        public string name { get; set; }
        public string geom_file { get; set; }
        public Dictionary<string, GeometryLoadoutReference> loadout { get; set; }
        public string[] materials { get; set; }
        public Dictionary<string, SubGeometryReference[]> sub_geometry { get; set; }
        public string[] tint_palettes { get; set; }
        public Dictionary<string, GeometryHelper> helpers { get; set; }
        public Dictionary<string, string> attrs { get; set; }
    }

    [Serializable]
    public class GeometryLoadoutReference
    {
        public string hardpoint { get; set; }
        public string[] geometry { get; set; }
    }

    [Serializable]
    public class SubGeometryReference
    {
        public XYZVector pos { get; set; }
        public RotationVector rotation { get; set; }
        public Dictionary<string, string> attrs { get; set; }
    }

    [Serializable]
    public class GeometryHelper
    {
        public XYZVector pos { get; set; }
        public RotationVector rotation { get; set; }
        public string name { get; set; }
    }

    [Serializable]
    public class ContainerInstance
    {
        public Dictionary<string, ContainerInstance> containers { get; set; }
        public string[] socs { get; set; }
        public Dictionary<string, string> lights { get; set; }
        public Dictionary<string, Dictionary<string, SocInstanceContainer>> instances { get; set; }
        public ContainerAttributes attrs { get; set; }
    }

    [Serializable]
    public class ContainerAttributes
    {
        public XYZVector pos { get; set; }
        public RotationVector rotation { get; set; }
        public string socpak { get; set; }
    }

    [Serializable]
    public class XYZVector
    {
        public float x { get; set; }
        public float y { get; set; }
        public float z { get; set; }
    }

    [Serializable]
    public class RotationVector
    {
        public float x { get; set; }
        public float y { get; set; }
        public float z { get; set; }
        public float w { get; set; }
    }

    #endregion

    #region Material JSON Definition

    [Serializable]
    public class MasterMaterialContainer
    {
        public MaterialMaster Material { get; set; }
    }

    [Serializable]
    public class MaterialMaster
    {
        public SubMaterialContainer SubMaterials { get; set; }
        public Dictionary<string, string> PublicParams { get; set; }

        [JsonProperty(PropertyName = "@MtlFlags")]
        public int MtlFlags { get; set; }
        [JsonProperty(PropertyName = "@MatTemplate")]
        public string MatTemplate { get; set; }
        [JsonProperty(PropertyName = "@MatSubTemplate")]
        public string MatSubTemplate { get; set; }
        [JsonProperty(PropertyName = "@vertModifType")]
        public int vertModifType { get; set; }
    }

    [Serializable]
    public class SubMaterialContainer
    {
        [JsonConverter(typeof(SingleValueArrayConverter<SubMat>))]
        public List<SubMat> Material { get; set; }
    }

    [Serializable]
    public class SubMat
    {
        public MatTextureContainer Textures { get; set; }
        public MatLayerContainer MatLayers { get; set; }
        public Dictionary<string, string> PublicParams { get; set; }
        [JsonProperty(PropertyName = "@Name")]
        public string Name { get; set; }
        [JsonProperty(PropertyName = "@MtlFlags")]
        public string MtlFlags { get; set; }
        [JsonProperty(PropertyName = "@MatTemplate")]
        public string MatTemplate { get; set; }
        [JsonProperty(PropertyName = "@MatSubTemplate")]
        public string MatSubTemplate { get; set; }
        [JsonProperty(PropertyName = "@Shader")]
        public string Shader { get; set; }
        [JsonProperty(PropertyName = "@StringGenMask")]
        public string StringGenMask { get; set; }
        [JsonProperty(PropertyName = "@SurfaceType")]
        public string SurfaceType { get; set; }
        [JsonProperty(PropertyName = "@Diffuse")]
        public string Diffuse { get; set; }
        [JsonProperty(PropertyName = "@Specular")]
        public string Specular { get; set; }
        [JsonProperty(PropertyName = "@Emissive")]
        public string Emissive { get; set; }
        [JsonProperty(PropertyName = "@Opacity")]
        public string Opacity { get; set; }
        [JsonProperty(PropertyName = "@Shininess")]
        public float Shininess { get; set; }
        [JsonProperty(PropertyName = "@Glow")]
        public float Glow { get; set; }
        [JsonProperty(PropertyName = "@AlphaTest")]
        public string AlphaTest { get; set; }
        [JsonProperty(PropertyName = "@vertModifType")]
        public string vertModifType { get; set; }
    }

    [Serializable]
    public class MatTextureContainer
    {
        [JsonConverter(typeof(SingleValueArrayConverter<MatTexture>))]
        public List<MatTexture> Texture { get; set; }
    }

    [Serializable]
    public class MatTexture
    {
        public TextureMods TexMod { get; set; }
        [JsonProperty(PropertyName = "@Map")]
        public string Map { get; set; }
        [JsonProperty(PropertyName = "@File")]
        public string File { get; set; }
        [JsonProperty(PropertyName = "@Filter")]
        public int Filter { get; set; }
        [JsonProperty(PropertyName = "@TexType")]
        public int TexType { get; set; }
        [JsonProperty(PropertyName = "@Used")]
        public int Used { get; set; }

    }

    [Serializable]
    public class TextureMods
    {
        [JsonProperty(PropertyName = "@TexMod_RotateType")]
        public int TexMod_RotateType { get; set; }
        [JsonProperty(PropertyName = "@TileU")]
        public float TileU { get; set; }
        [JsonProperty(PropertyName = "@TileV")]
        public float TileV { get; set; }
    }

    [Serializable]
    public class MatLayerContainer
    {
        [JsonConverter(typeof(SingleValueArrayConverter<MatLayer>))]
        public List<MatLayer> Layer { get; set; }    
    }

    [Serializable]
    public class MatLayer
    {
        [JsonProperty(PropertyName = "@Name")]
        public string Name { get; set; }
        [JsonProperty(PropertyName = "@Path")]
        public string Path { get; set; }
        [JsonProperty(PropertyName = "@Submtl")]
        public string Submtl { get; set; }
        [JsonProperty(PropertyName = "@TintColor ")]
        public string TintColor  { get; set; }
        [JsonProperty(PropertyName = "@WearTint")]
        public string WearTint { get; set; }
        [JsonProperty(PropertyName = "@GlossMult")]
        public float GlossMult { get; set; }
        [JsonProperty(PropertyName = "@WearGloss")]
        public float WearGloss { get; set; }
        [JsonProperty(PropertyName = "@UVTiling")]
        public float UVTiling { get; set; }
        [JsonProperty(PropertyName = "@HeightBias ")]
        public float HeightBias { get; set; }
        [JsonProperty(PropertyName = "@HeightScale")]
        public float HeightScale { get; set; }
        [JsonProperty(PropertyName = "@PaletteTint")]
        public float PaletteTint { get; set; }
    }

    #endregion


    #region Functions

    [MenuItem("Starfab/Open Importer")]
    public static void ShowWindow()
    {
        EditorWindow.GetWindow(typeof(SCBPImporter));
    }

    void OnGUI()
    {
        //if (!SessionState.GetBool("SCBPEditorLoaded", false))
        //{
        //try
        //{
        // SCBPImporterConfig config = JsonConvert.DeserializeObject<SCBPImporterConfig>(AssetDatabase.LoadAssetAtPath<TextAsset>(configSaveLocation).text);
        // blueprintSource = config.blueprintSource;
        // globalImportSettings = config.globalSettings;
        // lightImportSettings = config.lightImportSettings;
        //}
        //catch { }
        //SessionState.SetBool("SCBPEditorLoaded", true);
        //}

        //EditorGUI.BeginChangeCheck();

        GUILayout.Label("Directories", EditorStyles.boldLabel);
        blueprintSource = EditorGUILayout.ObjectField("Blueprint: ", blueprintSource, typeof(UnityEngine.Object), false);
        globalImportSettings.targetObject = EditorGUILayout.ObjectField("Target Object Parent", globalImportSettings.targetObject, typeof(GameObject), true) as GameObject;
        globalImportSettings.assetSources = EditorGUILayout.TextField("Asset Source Directory", globalImportSettings.assetSources);
        //globalImportSettings.assetDestination = EditorGUILayout.TextField("Asset Creation Directory", globalImportSettings.assetDestination);
        globalImportSettings.preferTIF = EditorGUILayout.Toggle("Prefer TIF files", globalImportSettings.preferTIF);
        globalImportSettings.overwriteTextures = EditorGUILayout.Toggle("Overwrite Existing Textures", globalImportSettings.overwriteTextures);
        globalImportSettings.overwriteMaterials = EditorGUILayout.Toggle("Overwrite Existing Materials", globalImportSettings.overwriteMaterials);

        // if (EditorGUI.EndChangeCheck())
        // {
        //     WriteSettingsToFile(globalImportSettings, lightImportSettings, blueprintSource);
        // }

        if (blueprintSource != null)
        {
            if (GUILayout.Button("Load Blueprint"))
            {
                globalImportSettings.importedBlueprint = ImportBlueprint(blueprintSource);
                availableLights = null;
            }
        }

        if (globalImportSettings.importedBlueprint != null)
        {
            if (GUILayout.Button("Create Light List"))
            {
                availableLights = CreateLightList(globalImportSettings.importedBlueprint);
                Debug.Log("Successfully loaded " + availableLights.Count + " Light definitions from source blueprint");
            }
            if (availableLights != null && globalImportSettings.targetObject != null)
            {

                //EditorGUI.BeginChangeCheck();

                lightImportSettings.fixTransforms = EditorGUILayout.Toggle("Fix Transforms", lightImportSettings.fixTransforms);
                lightImportSettings.state = (LightStateName)EditorGUILayout.EnumPopup("State Template: ", lightImportSettings.state);

                // if (EditorGUI.EndChangeCheck())
                // {
                //     WriteSettingsToFile(globalImportSettings, lightImportSettings, blueprintSource);
                // }

                // if (GUILayout.Button("Find Matching Lights in Scene"))
                // {
                //     foundLights = FindSceneLights(availableLights, globalImportSettings.targetObject);
                //     lightsFound = foundLights.Count;
                //     Debug.Log("Found " + lightsFound + " matches for light objects in children.");
                // }
                if (GUILayout.Button("Set lights from Blueprint"))
                {
                    foundLights = FindSceneLights(availableLights, globalImportSettings.targetObject);
                    Debug.Log("Found " + foundLights.Count + " matches for light objects in children.");
                    ImportLightData(foundLights, availableLights, globalImportSettings, lightImportSettings);
                }
            }

            if (GUILayout.Button("Create Material List"))
            {
                availableMaterials = CreateMaterialList(globalImportSettings, true);
                //Debug.Log("Successfully loaded " + availableMaterials.blueprintMaterials.Count + " material definitions from source blueprint.");
                //Debug.Log("Successfully loaded " + availableMaterials.loadedMaterials.Count + " material definitions from source directory.");
                //Debug.Log("Successfully loaded " + availableMaterials.loadedLayers.Count + " material layer definitions from source directory.");
            }
            if (availableMaterials != null)
            {
                if (GUILayout.Button("Find Matching materials from Scene"))
                {
                    foundMaterials = MatchSceneMaterials(availableMaterials, globalImportSettings.targetObject);
                    Debug.Log("Found " + foundMaterials.Count + " matching material names in child meshes.");
                }
                if (foundMaterials.Count > 0)
                {
                    if (GUILayout.Button("Generate Materials"))
                    {
                        CreateMaterials(foundMaterials, availableMaterials, globalImportSettings);
                    }
                }

                if (GUILayout.Button("Save Material List to File"))
                {
                    SaveMaterialDefinitions(availableMaterials, globalImportSettings);
                }
            }
        }
        else
        {
            GUILayout.Label("No blueprint loaded yet!");
        }
        if (GUILayout.Button("Assign generated materials to objects in scene"))
        {
            AssignMaterialsToScene(globalImportSettings);
        }

        if (GUILayout.Button("Revert materials in children to source"))
        {
            RevertMaterials(globalImportSettings.targetObject);
        }

        if (GUILayout.Button("Load Material List from File"))
        {
            availableMaterials = LoadMaterialDefinitions(globalImportSettings);
        }

        if (GUILayout.Button("[DEBUG] Purge used memory"))
        {
            availableMaterials = new MaterialDefinitions();
            GarbageCollector.CollectIncremental();
        }

        //prefabSource = EditorGUILayout.ObjectField("Prefabs Folder: ", prefabSource, typeof(UnityEngine.Object), false);


    }

    // private static UnityEngine.Object GetPathFromFolder(UnityEngine.Object obj, SerializedProperty property)
    // {
    //     UnityEngine.Object folderAssetObj = null;
    //     string existingFolderPath = property.stringValue;
    //     if (existingFolderPath != null)
    //     {
    //         folderAssetObj = AssetDatabase.LoadAssetAtPath<UnityEngine.Object>(existingFolderPath);
    //     }
    //     UnityEngine.Object newFolderAssetObj = EditorGUILayout.ObjectField(property.displayName, folderAssetObj, typeof(UnityEngine.Object), false);
    //     if (newFolderAssetObj == folderAssetObj)
    //     {
    //         return folderAssetObj;
    //     }
    //     if (newFolderAssetObj != null)
    //     {
    //         string newPath = AssetDatabase.GetAssetPath(newFolderAssetObj);
    //         if (newPath != null && System.IO.Directory.Exists(newPath))
    //         {
    //             property.stringValue = newPath;
    //             return newFolderAssetObj;
    //         }
    //     }
    //     return null;
    // }

    // private void WriteSettingsToFile(GlobalImportSettings globalSettings, LightImportSettings lightSettings, UnityEngine.Object sourceBP)
    // {
    //     SCBPImporterConfig config = new SCBPImporterConfig();
    //     config.blueprintSource = sourceBP;
    //     config.globalSettings = globalSettings;
    //     config.lightImportSettings = lightSettings;
    //     string configString = JsonConvert.SerializeObject(config);
    // }

    // private static void PopulatePrefabs(UnityEngine.Object prefabSource, GameObject sceneParent)
    // {
    //     string folderPath = AssetDatabase.GetAssetPath(prefabSource);


    // }

    #region File Handling
    private static bpContainer ImportBlueprint(UnityEngine.Object blueprint)
    {
        string bpPath = AssetDatabase.GetAssetPath(blueprint);
        string bpContent = System.IO.File.ReadAllText(bpPath);

        //JObject sourceBP = JObject.Parse(bpContent);
        //var socFiles = sourceBP.Value<JObject>("socs").Properties();

        //var socsDict = socFiles.ToDictionary(k => k.Name, v => v.Value);
        var import = Newtonsoft.Json.JsonConvert.DeserializeObject<bpContainer>(bpContent);
        Debug.Log("Source blueprint successfully loaded!");
        return import;

    }

    private static string ImportFile(string filePath, GlobalImportSettings settings, bool isCookie = false, bool isCubemap = false)
    {

        string originalFilePath = filePath;
        string sourcePath = settings.assetSources + "\\" + filePath;

        //this should also look for .tga files eventually
        if (filePath.EndsWith(".dds") || filePath.EndsWith(".png") || filePath.EndsWith(".tif"))
        {
            //Later: This will use "Prefer TIF" to check for tif files first, or png files first?
            filePath = FileSuffix(filePath, ".tif");
            sourcePath = settings.assetSources + "\\" + filePath;
            if (!File.Exists(sourcePath))
            {
                filePath = FileSuffix(filePath, ".png");
                sourcePath = settings.assetSources + "\\" + filePath;
                if (!File.Exists(sourcePath))
                {
                    filePath = FileSuffix(filePath, ".tga");
                    sourcePath = settings.assetSources + "\\" + filePath;
                    if (!File.Exists(sourcePath))
                    {
                        Debug.LogWarning("Failed to find file: " + originalFilePath);
                        return "";
                    }
                }
            }
        }

        string importPath = settings.assetDestination + "\\" + filePath;

        //var fileInfo = new FileInfo(sourcePath);

        if (isCubemap)
        {
            if (importPath.EndsWith(".tif"))
            {
                importPath = FileSuffix(importPath, "_cubemap.tif");
            }
            else if (importPath.EndsWith(".png"))
            {
                importPath = FileSuffix(importPath, "_cubemap.png");
            }
            else if (importPath.EndsWith(".tga"))
            {
                importPath = FileSuffix(importPath, "_cubemap.tga");
            }
        }

        //string targetDir = Regex.Match(importPath, @"(.*\/).*").ToString();
        string targetDir = Path.GetDirectoryName(importPath);
        var directoryInfo = new DirectoryInfo(targetDir);
        if (!directoryInfo.Exists)
        {
            directoryInfo.Create();
            File.Copy(sourcePath, importPath);
            try { ProcessTexture(importPath, isCookie); }
            catch { Debug.LogWarning("Failed to process texture: " + importPath); }
        }
        else if (!File.Exists(importPath) || settings.overwriteTextures)
        {
            File.Copy(sourcePath, importPath);
            try { ProcessTexture(importPath, isCookie); }
            catch { Debug.LogWarning("Failed to process texture: " + importPath); }
        }

        return importPath;
    }

    private static void ProcessTexture(string targetFile, bool isCookie = false)
    {
        //Debug.Log("Processing Texture: " + targetFile);
        var importer = (TextureImporter)AssetImporter.GetAtPath(targetFile);

        if (importer == null)
        {
            AssetDatabase.ImportAsset(targetFile);
            importer = (TextureImporter)AssetImporter.GetAtPath(targetFile);
            if (importer == null)
            {
                Debug.LogError("Failed to import!");
                return;
            }
        }

        //var compareImporter = new TextureImporter();
        //compareImporter = importer;


        if (isCookie)
        {
            importer.textureType = TextureImporterType.Cookie;
            if (targetFile.Contains("_cubemap"))
            {
                importer.textureShape = TextureImporterShape.Texture2D;
                importer.generateCubemap = TextureImporterGenerateCubemap.Spheremap;
                importer.wrapModeU = TextureWrapMode.Clamp;
                importer.wrapModeV = TextureWrapMode.Clamp;
                importer.wrapModeW = TextureWrapMode.Clamp;
                importer.borderMipmap = false;
                //UpdateTextureSettings(importer, "cookieLightType", 2);
            }
            // else
            // {
            //     importer.textureType = TextureImporterType.Cookie;
            // }
            importer.alphaSource = TextureImporterAlphaSource.FromGrayScale;
            importer.alphaIsTransparency = false;
            importer.sRGBTexture = false;
        }
        else if (targetFile.Contains("_ddn") && !targetFile.Contains(".gloss"))
        {
            importer.textureType = TextureImporterType.NormalMap;
        }
        else if (targetFile.Contains("_detail"))
        {
            importer.textureType = TextureImporterType.NormalMap;
            importer.swizzleR = TextureImporterSwizzle.G;
            importer.swizzleG = TextureImporterSwizzle.A;
            importer.swizzleB = TextureImporterSwizzle.R;
            importer.swizzleA = TextureImporterSwizzle.B;
        }
        else
        {
            importer.textureType = TextureImporterType.Default;
            if (targetFile.Contains("_diff")) { importer.sRGBTexture = true; }
            else { importer.sRGBTexture = false; }
            importer.alphaSource = TextureImporterAlphaSource.FromInput;
            importer.alphaIsTransparency = false;
        }
        //importer.isReadable = true;

        importer.streamingMipmaps = true;
        importer.mipmapFilter = TextureImporterMipFilter.KaiserFilter;
        importer.mipMapsPreserveCoverage = true;
        importer.allowAlphaSplitting = true;

        //if (!Equals(importer, compareImporter))
        //{
            importer.SaveAndReimport();
        //}
            //We don't have the ability to directly set the light type for a cookie, for some reason...
            //So instead we have to manually edit the .meta file and refresh the database.

            // if (importer.name.Contains("_cubemap"))
            // {
            //     string metaFile = targetFile + ".meta";
            //     if (File.ReadAllText(metaFile).Contains("cookieLightType: 0"))
            //     {
            //         File.WriteAllText(metaFile, Regex.Replace(File.ReadAllText(metaFile), "cookieLightType: 0", "cookieLightType: 2"));
            //         //AssetDatabase.Refresh();
            //     }
            // }
    }

    private static string GenerateGlossMap(string targetFile, GlobalImportSettings settings)
    {
        Debug.Log("Generating glossmap for normal texture: " + targetFile);
        string sourcePath = settings.assetDestination + "\\" + targetFile;
        string importPath = sourcePath.ReplaceLast(".", ".glossmap.");
        if (!File.Exists(importPath) || settings.overwriteTextures)
        {
            File.Copy(sourcePath, importPath);
            //try { 
            //Debug.Log("Copying file to: " + importPath);
                ProcessTexture(importPath); //}
            //catch { Debug.LogWarning("Failed to process texture: " + importPath); }
        }

        return importPath;
    }


   /*  private static void ProcessTexture(string targetFile, bool isCookie = false)
      {
          Debug.Log("Processing Texture: " + targetFile);
          AssetDatabase.ImportAsset(targetFile);
          var importer = (TextureImporter)AssetImporter.GetAtPath(targetFile);
          bool fileWasChanged = false;

          if (importer == null)
          {
              Debug.LogError("Failed to import!");
              return;
          }
          //importer.isReadable = true;
          //fileWasChanged |= TryChangeImportSettings(() => importer.streamingMipmaps, prop => importer.streamingMipmaps = prop, true);
          //fileWasChanged |= TryChangeImportSettings(importer => importer.streamingMipmaps, true);
          fileWasChanged |= UpdateTextureSettings(importer, "streamingMipmaps", true);
          fileWasChanged |= UpdateTextureSettings(importer, "mipmapFilter", TextureImporterMipFilter.KaiserFilter);
          fileWasChanged |= UpdateTextureSettings(importer, "mipMapsPreserveCoverage", true);
          fileWasChanged |= UpdateTextureSettings(importer, "allowAlphaSplitting", true);

          if (isCookie)
          {
              fileWasChanged |= UpdateTextureSettings(importer, "textureType", TextureImporterType.Cookie);
              fileWasChanged |= UpdateTextureSettings(importer, "alphaSource", TextureImporterAlphaSource.FromGrayScale);
              if (importer.name.Contains("_cubemap"))
              {
                  fileWasChanged |= UpdateTextureSettings(importer, "textureShap", TextureImporterShape.TextureCube);
                  fileWasChanged |= UpdateTextureSettings(importer, "generateCubemap", TextureImporterAlphaSource.FromGrayScale);
                  importer.textureShape = TextureImporterShape.TextureCube;
                  importer.generateCubemap = TextureImporterGenerateCubemap.Spheremap;
              }
          }
          else if (importer.name.Contains("_ddn") && !importer.name.Contains(".gloss"))
          {
              importer.textureType = TextureImporterType.NormalMap;
          }
          else
          {
              importer.textureType = TextureImporterType.Default;
              importer.sRGBTexture = false;
              importer.alphaSource = TextureImporterAlphaSource.FromInput;
              importer.alphaIsTransparency = false;
              if (importer.name.Contains("_detail"))
              {
                  importer.swizzleR = TextureImporterSwizzle.G;
                  importer.swizzleG = TextureImporterSwizzle.A;
                  importer.swizzleB = TextureImporterSwizzle.R;
                  importer.swizzleA = TextureImporterSwizzle.B;
              }
          }
          if (fileWasChanged)
          {
              importer.SaveAndReimport();
          }
      } */

    // private static bool UpdateTextureSettings<T>(TextureImporter importer, string param, T val)
    // {
    //     PropertyInfo prop = importer.GetType().GetProperty(param);
    //     if (!Equals(prop.GetValue(importer), val))
    //     {
    //         prop.SetValue(importer, Convert.ChangeType(val, prop.PropertyType));
    //         return true;
    //     }
    //     return false;
    // }

    // private static bool TryChangeImportSettings<T>(Func<T> getProp, Action<T> setProp, T newProp)
    // {
    //     if (!Equals(getProp(), newProp))
    //     {
    //         setProp(newProp);
    //         return true;
    //     }
    //     return false;
    // }

    // private static bool TryChangeImportSettings<T>(this T target, Expression<Func<T>> exp, T propVal)
    // {
    //     var expProp = (PropertyInfo)((MemberExpression)exp.Body).Member;
    //     if (!Equals(expProp.GetValue(target, null), propVal))
    //     {
    //         expProp.SetValue(target, propVal, null);
    //         return true;
    //     }
    //     return false;
    // }

    private static string FileSuffix(string source, string suffix)
    {
        for (int i = source.Length - 1; i >= 0; i--)
        {
            if (source[i] == "."[0])
            {
                //Looks to find the closest period to the end, and replaces the suffix
                source = source.Remove(i);
                return source + suffix;
            }
            if (i < source.Length - 6 || i == 0)
            {
                return source + suffix;
            }
        }
        return null;
    }

    private static void SaveMaterialDefinitions(MaterialDefinitions matDefs, GlobalImportSettings settings)
    {
        string jsonText = JsonConvert.SerializeObject(matDefs);
        if (!Directory.Exists(settings.configFilePath))
        {
            Directory.CreateDirectory(settings.configFilePath);
        }

        //File.Create(settings.configFilePath + "/Saved_Materials.Json");
        File.WriteAllText(settings.configFilePath + "/Saved_Materials.Json", jsonText);
    }

    private static MaterialDefinitions LoadMaterialDefinitions(GlobalImportSettings settings)
    {
        if (File.Exists(settings.configFilePath + "/Saved_Materials.Json"))
        {
            return JsonConvert.DeserializeObject<MaterialDefinitions>(File.ReadAllText(settings.configFilePath + "/Saved_Materials.Json"));
        }
        else { return null; }
    }

    #endregion

    #region Material Handling

    private MaterialDefinitions CreateMaterialList(GlobalImportSettings settings, bool searchFolders = false)
    {
        if (!Directory.Exists(settings.assetSources + @"\Objects") || !settings.assetSources.ToLower().Contains("data"))
        {
            Debug.LogWarning("Asset source directory does not appear to be valid. Please ensure the directory is correct before initiating recursive material search.");
            return null;
        }

        MaterialDefinitions returnDefs = new MaterialDefinitions();

        List<string> checkedMaterials = new List<string>();
        Dictionary<string, SubMat> bpImportedMats = new Dictionary<string, SubMat>();
        Dictionary<string, SubMat> importedMats = new Dictionary<string, SubMat>();
        //Dictionary<string, SubMat> importedLayers = new Dictionary<string, SubMat>();

        foreach (GeometryInstance geo in settings.importedBlueprint.geometry.Values)
        {
            foreach (string mat in geo.materials)
            {
                string matSearch = settings.assetSources + @"\" + mat;
                if (!checkedMaterials.Contains(matSearch))
                {
                    checkedMaterials.Add(matSearch);
                    string matNameBase = FileSuffix(mat.Split("/").Last().Split(@"\").Last(), "_mtl_");
                    List<SubMat> materials = LoadMaterial(mat, settings);
                    foreach (SubMat subMat in materials)
                    {
                        //Debug.Log("Adding Material to list: " + subMat.Name);
                        if (subMat.Shader != "Layer" && subMat.Name != null && subMat.Name != "")
                        {
                            string subMatName = String.Concat(matNameBase, subMat.Name).ToLower();
                            if (!bpImportedMats.ContainsKey(subMatName))
                            {
                                bpImportedMats.Add(subMatName, subMat);
                            }
                        }
                    }
                }
            }
        }

        if (searchFolders)
        {
            foreach (string mat in Directory.GetFiles(settings.assetSources, "*.mtl", SearchOption.AllDirectories))
            {
                if (!checkedMaterials.Contains(mat))
                {
                    checkedMaterials.Add(mat);
                    string matNameBase = FileSuffix(mat.Split("/").Last().Split(@"\").Last(), "_mtl_");
                    List<SubMat> materials = LoadMaterial(mat, settings, false);
                    foreach (SubMat subMat in materials)
                    {
                        //Debug.Log("Adding Material to list: " + subMat.Name);
                        if (subMat.Shader != "Layer" && subMat.Name != null && subMat.Name != "")
                        {
                            string subMatName = String.Concat(matNameBase, subMat.Name).ToLower();
                            if (!importedMats.ContainsKey(subMatName))
                            {
                                importedMats.Add(subMatName, subMat);
                            }
                        }
                    }
                }
            }
        }

        returnDefs.blueprintMaterials = bpImportedMats;
        returnDefs.loadedMaterials = importedMats;
        //returnDefs.loadedLayers = importedLayers;

        return returnDefs;
    }

    private static List<SubMat> LoadMaterial(string mtl, GlobalImportSettings settings, bool addSourceDir = true)
    {
        List<SubMat> loadedMats = new List<SubMat>();

        string sourcePath = mtl;
        string fileText = "";
        //foreach (string mtl in mtlPaths)
        //{
        if (addSourceDir)
        {
            sourcePath = settings.assetSources + "\\" + mtl;
        }

        //Debug.Log("Loading Material: " + sourcePath);
        fileText = File.ReadAllText(sourcePath);
        if (fileText.StartsWith(@"<"))
        {
            //If mtl files were exported as XML, convert them into JSON first
            XmlDocument xml;
            xml = new XmlDocument();
            xml.LoadXml(fileText);
            fileText = JsonConvert.SerializeXmlNode(xml);
        }
        if (fileText.Contains("SubMaterials"))
        {
            try { loadedMats.AddRange(JsonConvert.DeserializeObject<MasterMaterialContainer>(fileText).Material.SubMaterials.Material); } catch { }
        }
        else
        {
            try { loadedMats.AddRange(JsonConvert.DeserializeObject<SubMaterialContainer>(fileText).Material); } catch { }
        }
        //}

        return loadedMats;
    }


    private static List<string> MatchSceneMaterials(MaterialDefinitions matDefs, GameObject sceneParent)
    {
        List<string> foundMats = new List<string>();

        var mats = matDefs.blueprintMaterials;
        //var layers = matDefs.loadedLayers;

        // foreach (string s in mats.Keys)
        // {
        //     Debug.Log("Material found in blueprint: " + s);
        // }

        foreach (MeshRenderer mesh in sceneParent.GetComponentsInChildren<MeshRenderer>())
        {
            foreach (Material m in mesh.sharedMaterials)
            {
                string mName = m.name.ToLower();
                // if (mName.EndsWith(@" (Instance)"))
                // {
                //     mName = mName.ReplaceLast(@" (Instance)", "");
                // }
                //mName.Remove(mName[mName.Count() - 11], 10);
                if (!foundMats.Contains(mName))
                {
                    if (mats.ContainsKey(mName))
                    {
                        foundMats.Add(mName);
                    }
                    else if (matDefs.loadedMaterials.ContainsKey(mName))
                    {
                        foundMats.Add(mName);
                    }
                    else
                    {
                        Debug.LogWarning("Scene material " + mName + " has no match in loaded materials.");
                    }
                }
            }
        }
        
        foreach (SkinnedMeshRenderer mesh in sceneParent.GetComponentsInChildren<SkinnedMeshRenderer>())
        {
            foreach (Material m in mesh.sharedMaterials)
            {
                string mName = m.name.ToLower();
                // if (mName.EndsWith(@" (Instance)"))
                // {
                //     mName = mName.ReplaceLast(@" (Instance)", "");
                // }
                //mName.Remove(mName[mName.Count() - 11], 10);
                if (!foundMats.Contains(mName))
                {
                    if (mats.ContainsKey(mName))
                    {
                        foundMats.Add(mName);
                    }
                    else if (matDefs.loadedMaterials.ContainsKey(mName))
                    {
                        foundMats.Add(mName);
                    }
                    else
                    {
                        Debug.LogWarning("Scene material " + mName + " has no match in loaded materials.");
                    }
                }
            }
        }

        return foundMats;
    }

    private static void RevertMaterials(GameObject sceneParent)
    {
        foreach (MeshRenderer mesh in sceneParent.GetComponentsInChildren<MeshRenderer>())
        {
            SerializedObject obj = new SerializedObject(mesh);
            PrefabUtility.RevertObjectOverride(mesh, UnityEditor.InteractionMode.AutomatedAction);
        }
        
        foreach (SkinnedMeshRenderer mesh in sceneParent.GetComponentsInChildren<SkinnedMeshRenderer>())
        {
            SerializedObject obj = new SerializedObject(mesh);
            PrefabUtility.RevertObjectOverride(mesh, UnityEditor.InteractionMode.AutomatedAction);
        }
    }

    private static void CreateMaterials(List<string> sceneMats, MaterialDefinitions matDefs, GlobalImportSettings settings)
    {

        ShaderList shaders = new ShaderList();

        shaders.illumShader = Shader.Find("Star Citizen/Illum");
        shaders.shadowlessShader = Shader.Find("Star Citizen/Illum (No Shadows)");
        shaders.decalShader = Shader.Find("Star Citizen/Illum Parallax");
        shaders.emitShader = Shader.Find("Star Citizen/Illum.Emit");
        shaders.pomShader = Shader.Find("Star Citizen/Decals POM");
        shaders.hardSurfaceShader = Shader.Find("Star Citizen/HardSurface");
        shaders.layerBlendShader = Shader.Find("Star Citizen/Layer Blend");
        shaders.displayScreenShader = Shader.Find("Star Citizen/Display Screen");
        shaders.glassShader = Shader.Find("Star Citizen/Glass");
        var directoryInfo = new DirectoryInfo(settings.materialGenerationPath);
        //Debug.Log(directoryInfo.FullName);
        if (!directoryInfo.Exists)
        {
            directoryInfo.Create();
        }

        // Material illumBaseMatProxy = AssetDatabase.LoadAssetAtPath<Material>(@"Assets/Starfab/Proxy Materials/SC_Illum_Base_Proxy_Mat.mat");
        // Material illumDecalMatProxy = AssetDatabase.LoadAssetAtPath<Material>(@"Assets/Starfab/Proxy Materials/SC_Illum_Decal_Proxy_Mat.mat");
        // Material illumEmitMatProxy = AssetDatabase.LoadAssetAtPath<Material>(@"Assets/Starfab/Proxy Materials/SC_Illum_Emit_Proxy_Mat.mat");
        // Material layerBlendMatProxy = AssetDatabase.LoadAssetAtPath<Material>(@"Assets/Starfab/Proxy Materials/SC_LayerBlend_Proxy_Mat.mat");
        // Material hardSurfaceMatProxy = AssetDatabase.LoadAssetAtPath<Material>(@"Assets/Starfab/Proxy Materials/SC_HardSurface_Proxy_Mat.mat");
        // Material glassMatProxy = AssetDatabase.LoadAssetAtPath<Material>(@"Assets/Starfab/Proxy Materials/SC_Glass_Proxy_Mat.mat");
        // Material displayScreenMatProxy = AssetDatabase.LoadAssetAtPath<Material>(@"Assets/Starfab/Proxy Materials/SC_Display_Screen_Proxy_Mat.mat");
        // Material pomMatProxy = AssetDatabase.LoadAssetAtPath<Material>(@"Assets/Starfab/Proxy Materials/SC_POM_Proxy_Mat.mat");

        var bpMats = matDefs.loadedMaterials;
        var bpLayers = matDefs.loadedLayers;

        List<string> failedMatTypes = new List<string>();
        List<string> failedTextures = new List<string>();

        foreach (string matName in sceneMats)
        {
            string targetPath = settings.materialGenerationPath + "/" + matName + ".mat";
            //Debug.Log("Generating Material: " + matName);

            if (!settings.overwriteMaterials && AssetDatabase.LoadAssetAtPath<Material>(targetPath) != null)
            {
                continue;
            }
            // Material matFile = AssetDatabase.LoadAssetAtPath<Material>(targetPath);
            // if (matFile == null)
            // {
            //     matFile = new Material(shaders.illumShader);
            //     try
            //     {
            //         AssetDatabase.CreateAsset(matFile, targetPath);
            //     }
            //     catch { Debug.LogWarning("Failed to generate material: " + targetPath); }
            //     //continue;
            // }

            // var importer = AssetImporter.GetAtPath(targetPath);

            SubMat currentMat = bpMats[matName];
            if (failedMatTypes.Contains(currentMat.Shader))
            {
                Debug.LogWarning("Failed to create material: " + matName + " with unknown shader type: " + currentMat.Shader);
                continue;
            }
            Dictionary<int, MatTextureReference> matTextures = new Dictionary<int, MatTextureReference>();

            try
            {
                string ddnaSearchPath = "";
                foreach (MatTexture texRef in currentMat.Textures.Texture)
                {
                    //Textures: 
                    //Ignore "nearest_cubemap" (This may actually be useful for grabbing from reflection probes)
                    //Ignore "$RenderToTexture" (May be useful for the interactive display screens?)
                    //Special handling case for "$TintPaletteDecal"?  This applies a special decal node that has not yet been transferred over
                    if (texRef.File == null)
                    {
                        continue;
                    }
                    if (texRef.File.Contains("$RenderToTexture") || texRef.File.Contains("nearest_cubemap") || texRef.File.Contains("$TintPaletteDecal"))
                    {
                        continue;
                    }
                    if (failedTextures.Contains(texRef.File))
                    {
                        continue;
                    }
                    MatTextureReference newtex = new MatTextureReference();
                    int texSlot = Convert.ToInt16(texRef.Map.Remove(0, 7));
                    if (currentMat.Shader == "MeshDecal")
                    {
                        if (texSlot == 2) { texSlot = 4; }
                        else if (texSlot == 3) { texSlot = 2; }
                        else if (texSlot == 4) { texSlot = 8; }
                    }

                    if (texSlot == 3)
                    {
                        //Debug.LogWarning("Looking for Glossmap: " + texRef.File.ReplaceLast(".", ".glossmap."));
                        if (!texRef.File.ToLower().Contains(".gloss"))
                        {
                            newtex.texturePath = ImportFile(texRef.File.ReplaceLast(".", ".glossmap."), settings);
                            if (newtex.texturePath == "")
                            {
                                //Debug.LogWarning("Failed to find Glossmap, looking for normal ddn: ");
                                newtex.texturePath = ImportFile(texRef.File, settings);
                            }
                        }
                        else
                        {
                            newtex.texturePath = ImportFile(texRef.File, settings);
                        }
                    }
                    //newtex.textureSlot = texSlot;
                    else { newtex.texturePath = ImportFile(texRef.File, settings); }
                    if (newtex.texturePath == "")
                    {
                        failedTextures.Add(texRef.File);
                        continue;
                    }
                    if (texSlot == 2)
                    {
                        ddnaSearchPath = texRef.File;
                    }
                    if (texRef.TexMod != null)
                    {
                        newtex.textureTiling = new Vector2(texRef.TexMod.TileU, texRef.TexMod.TileV);
                    }
                    else { newtex.textureTiling = new Vector2(1.0f, 1.0f); }
                    matTextures.Add(texSlot, newtex);
                }
                if (!matTextures.ContainsKey(3))
                {
                    if (matTextures.ContainsKey(2))
                    {
                        MatTextureReference newTex = new MatTextureReference();
                        newTex.texturePath = ImportFile(ddnaSearchPath.ReplaceLast(".", ".glossmap."), settings);
                        if (newTex.texturePath != "")
                        {
                            newTex.textureTiling = matTextures[2].textureTiling;
                            matTextures.Add(3, newTex);
                        }
                    }
                }
            }
            catch { }


            // try
            // {
            //     if (matTextures.ContainsKey(3))
            //     {
            //         if (!matTextures[3].texturePath.ToLower().Contains(".glossmap"))
            //         {
            //             matTextures[3].texturePath = GenerateGlossMap(matTextures[3].texturePath, settings);
            //         }
            //     }
            //     else if (matTextures.ContainsKey(2))
            //     {
            //         MatTextureReference newGloss = new MatTextureReference();
            //         newGloss.textureTiling = matTextures[2].textureTiling;
            //         newGloss.texturePath = GenerateGlossMap(matTextures[2].texturePath, settings);
            //         matTextures.Add(3, newGloss);
            //     }
            // }
            // catch { }

            //Material mat = new Material(Shader.Find("Standard (Specular setup)"));
            //Material mat = new Material(illumBaseMatProxy);
            Material mat = new Material(shaders.illumShader);
            mat.name = matName;
            if (currentMat.Shader == "Illum")
            {
                //mat.shader = shaders.illumShader;
                if (currentMat.MatLayers != null)
                {
                    Debug.LogWarning("Material: " + matName + " is using sub-layers but has the Illum shader applied.");
                }

                if (matName.Contains("_pom"))
                {
                    mat.shader = shaders.pomShader;
                    //mat = new Material(pomMatProxy);

                    //Scale, Bias, Layers, NonPlanar, AlphaMidLevelControl, Brightness
                }
                else if (matName.Contains("_decal") && !matName.Contains("_non_decal") || currentMat.StringGenMask.Contains("%DECAL"))
                {
                    mat.shader = shaders.shadowlessShader;
                    //mat = new Material(illumDecalMatProxy);
                    Color diffColor = mat.GetColor("_DiffuseColor");
                    diffColor.a = 0.0f;
                    try { mat.SetColor("_DiffuseColor", diffColor); } catch { }
                    try { mat.SetFloat("_UseAlpha", 1.0f); } catch { }
                }
                else if (matName.Contains("glow"))
                {
                    mat.shader = shaders.emitShader;
                    //mat = new Material(illumEmitMatProxy);
                    //If matname contains "_link", geom link property to 1
                    if (matName.Contains("__Link"))
                    {
                        try { mat.SetFloat("_GeomLink", 1.0f); } catch { }
                    }
                }
                else if (currentMat.StringGenMask.Contains("PARALLAX_OCCLUSION_MAPPING"))
                {
                    mat.shader = shaders.decalShader;
                }
                else if (matName.ToLower().Contains("rtt_text_to_decal"))
                {
                    continue;
                    mat.shader = shaders.decalShader;
                    //mat = new Material(illumDecalMatProxy);
                    Color rttColor = mat.GetColor("_DiffuseColor");
                    rttColor.a = 0.0f;
                    try { mat.SetColor("_DiffuseColor", rttColor); } catch { }
                }

                if (currentMat.AlphaTest != null || currentMat.StringGenMask.Contains("USE_OPACITY_MAP"))
                {
                    try { mat.SetFloat("_UseAlpha", 1.0f); } catch { }
                }
            }
            else if (currentMat.Shader == "MeshDecal")
            {

                if (matName.Contains("_pom"))
                {
                    mat.shader = shaders.pomShader;
                    //mat = new Material(pomMatProxy);

                    //Scale, Bias, Layers, NonPlanar, AlphaMidLevelControl, Brightness
                }
                else if (currentMat.StringGenMask.Contains("PARALLAX_OCCLUSION_MAPPING"))
                {
                    mat.shader = shaders.decalShader;
                }
                else
                {
                    mat.shader = shaders.shadowlessShader;
                    //mat = new Material(illumDecalMatProxy);
                    Color diffColor = mat.GetColor("_DiffuseColor");
                    diffColor.a = 0.0f;
                    try { mat.SetColor("_DiffuseColor", diffColor); } catch { }
                    try { mat.SetFloat("_UseAlpha", 1.0f); } catch { }
                }
            }
            else if (currentMat.Shader == "HardSurface")
            {
                mat.shader = shaders.hardSurfaceShader;
                //mat = new Material(hardSurfaceMatProxy);
            }
            else if (currentMat.Shader == "DisplayScreen")
            {
                mat.shader = shaders.displayScreenShader;
                //mat = new Material(displayScreenMatProxy);
                //If "RTT_HUD" in matname => diff alpha to 0, usealpha to 1
                if (matName.ToLower().Contains("rtt_hud"))
                {
                    Color rttColor = mat.GetColor("_DiffuseColor");
                    rttColor.a = 0.0f;
                    try { mat.SetColor("_DiffuseColor", rttColor); } catch { }
                    try { mat.SetFloat("_UseAlpha", 1.0f); } catch { }
                }
            }
            else if (currentMat.Shader == "GlassPBR" || currentMat.Shader == "Glass")
            {
                mat.shader = shaders.glassShader;
                //mat = new Material(glassMatProxy);
            }
            else if (currentMat.Shader.ToLower() == "layerblend" || currentMat.Shader.ToLower() == "layerblend_v2")
            {
                mat.shader = shaders.layerBlendShader;
                //mat = new Material(layerBlendMatProxy);
            }
            else if (currentMat.Shader.ToLower() == "cloth")
            {
                //We're already set to illum
            }
            else
            {
                //Known missing shader types:
                //Hologramcig
                //HumanSkin
                //IES
                failedMatTypes.Add(currentMat.Shader);
                Debug.LogWarning("Failed to create material: " + matName + " with unknown shader type: " + currentMat.Shader);
                continue;
            }
            Debug.Log("Generating Material: " + matName + ", with shader of type: " + mat.shader);

            string[] splitProp;
            Color propColor;
            try
            {
                splitProp = currentMat.Diffuse.Split(",");
                if (currentMat.Shader == "GlassPBR" || currentMat.Shader == "Glass" || currentMat.Shader == "DisplayScreen")
                {
                    try { propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), Convert.ToSingle(currentMat.PublicParams["@Thickness"])); }
                    catch { propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), mat.GetColor("_BaseColor").a); }
                }
                else { propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), mat.GetColor("_BaseColor").a); }
                mat.SetColor("_BaseColor", propColor.gamma);
            }
            catch { }

            try
            {
                splitProp = currentMat.Emissive.Split(",");
                propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), mat.GetColor("_Emission").a);
                mat.SetColor("_Emission", propColor.gamma);
            }
            catch { }

            try { mat.SetColor("_DDNAColor", new Color(0.5f, 0.5f, 1.0f, currentMat.Shininess / 255.0f)); } catch { }

            try
            {
                splitProp = currentMat.Specular.Split(",");
                propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), mat.GetColor("_SpecularColor").a);
                mat.SetColor("_SpecularColor", propColor);
            }
            catch { }

            try { mat.SetFloat("_Glow", currentMat.Glow); } catch { }

            //Normal strength defaults to 1


            //Diff Texture; Slot 1
            try
            {
                mat.SetTexture("_Diffuse", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[1].texturePath));
                mat.SetTextureScale("_Diffuse", matTextures[1].textureTiling);
            }
            catch { }

            //DDNA Texture; Slot 2
            try
            {
                mat.SetTexture("_ddna", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[2].texturePath));
                mat.SetTextureScale("_ddna", matTextures[2].textureTiling);
            }
            catch { }

            //DDNA Glossmap Texture; is sometimes the same, is sometimes separate; Slot 3
            if (matTextures.ContainsKey(3))
            {
                // if (!matTextures.ContainsKey(2) || matTextures[2].texturePath != matTextures[3].texturePath)
                // {
                //     try
                //     {
                //         mat.SetTexture("_DDNAGlossmap", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[3].texturePath));
                //         mat.SetTextureScale("_DDNAGlossmap", matTextures[3].textureTiling);
                //     }
                //     catch { }
                // }
                // try
                // {
                //     mat.SetTexture("_DDNAGlossmap", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[2].texturePath.ReplaceLast(".", ".glossmap.")));
                //     mat.SetTextureScale("_DDNAGlossmap", matTextures[2].textureTiling);
                // }
                // catch { }  
                try
                {
                    mat.SetTexture("_DDNAGlossmap", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[3].texturePath));
                    mat.SetTextureScale("_DDNAGlossmap", matTextures[3].textureTiling);
                }
                catch { }
            }
            else
            {
                try
                {
                    mat.SetTexture("_DDNAGlossmap", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[2].texturePath.ReplaceLast(".", ".glossmap.")));
                    mat.SetTextureScale("_DDNAGlossmap", matTextures[2].textureTiling);
                }
                catch { }
            }

            //Specular Texture; Slot 4
            try
            {
                mat.SetTexture("_Specular", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[4].texturePath));
                mat.SetTextureScale("_Specular", matTextures[4].textureTiling);
            }
            catch { }

            //Detail Texture; Slot 6
            try
            {
                mat.SetTexture("_Detail", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[6].texturePath));
                mat.SetTextureScale("_Detail", matTextures[6].textureTiling);
            }
            catch
            {
                try
                {
                    mat.SetTexture("_TexSlot6", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[6].texturePath));
                    mat.SetTextureScale("_TexSlot6", matTextures[6].textureTiling);
                }
                catch { }
            }

            //Heightmap (Disp) Texture; Slot 8
            try
            {
                mat.SetTexture("_Disp", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[8].texturePath));
                mat.SetTextureScale("_Disp", matTextures[8].textureTiling);
            }
            catch { }

            //Decal Texture; Slot 9
            try
            {
                mat.SetTexture("_Decal", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[9].texturePath));
                mat.SetTextureScale("_Decal", matTextures[9].textureTiling);
            }
            catch { }

            //WDA Texture; Slot 11; this is also a Disp texture, but is not presently used in any existing shaders
            //try 
            //{ 
            // mat.SetTexture("_WDA", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[11].texturePath)); 
            // mat.SetTextureScale("_WDA", matTextures[11].textureTiling);
            // } catch { }

            //Blend Texture; Slot 12
            try
            {
                mat.SetTexture("_Blend", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[12].texturePath));
                mat.SetTextureScale("_Blend", matTextures[12].textureTiling);
            }
            catch { }

            //Tex slot 13: Exists, but seems to be poorly defined. Either a blendmap or a detail map? Or blend for details? 
            try
            {
                mat.SetTexture("_TexSlot13", AssetDatabase.LoadAssetAtPath<Texture>(matTextures[13].texturePath));
                mat.SetTextureScale("_TexSlot13", matTextures[13].textureTiling);
            }
            catch { }

            //tex slots 5, 7, 10 are all unknowns

            //try: BlendFactor (0), BlendFalloff (0), HeightBias (0.5), PomDisplacement (0)
            try
            {
                splitProp = currentMat.PublicParams["@BlendLayer2DiffuseColor"].Split(",");
                propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), 1.0f);
                mat.SetColor("_BlendLayer2DiffuseColor", propColor);
            }
            catch { }

            try
            {
                splitProp = currentMat.PublicParams["@BlendLayer2SpecularColor"].Split(",");
                propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), 1.0f);
                mat.SetColor("_BlendLayer2SpecularColor", propColor);
            }
            catch { }

            try
            {
                splitProp = currentMat.PublicParams["@BlendLayer2Glossiness"].Split(",");
                propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), 1.0f);
                mat.SetFloat("_BlendLayer2Glossiness", Convert.ToSingle(currentMat.PublicParams["@BlendLayer2Glossiness"]) / 255.0f);
            }
            catch { }

            try { mat.SetFloat("_BlendFactor", Convert.ToSingle(currentMat.PublicParams["@BlendFactor"])); } catch { }
            try { mat.SetFloat("_BlendFalloff", Convert.ToSingle(currentMat.PublicParams["@BlendFalloff"])); } catch { }
            try { mat.SetFloat("_HeightBias", Convert.ToSingle(currentMat.PublicParams["@HeightBias"])); } catch { }
            try { mat.SetFloat("_POMDisplacement", Convert.ToSingle(currentMat.PublicParams["@PomDisplacement"])); } catch { }
            try { mat.SetFloat("_DetailDiffuseScale", Convert.ToSingle(currentMat.PublicParams["@DetailDiffuseScale"])); } catch { }
            try { mat.SetFloat("_DetailGlossScale", Convert.ToSingle(currentMat.PublicParams["@DetailGlossScale"])); } catch { }
            try { mat.SetFloat("_DetailBumpScale", Convert.ToSingle(currentMat.PublicParams["@DetailBumpScale"])); } catch { }

            if (currentMat.MatLayers != null)
            {
                if (currentMat.MatLayers.Layer != null)
                {
                    Dictionary<string, SubMat> loadedLayers = new Dictionary<string, SubMat>();
                    foreach (MatLayer matLayer in currentMat.MatLayers.Layer)
                    {
                        string layerPath = matLayer.Path;
                        try
                        {
                            if (!loadedLayers.ContainsKey(layerPath))
                            {
                                SubMat layer = LoadMaterial(layerPath, settings)[0];
                                loadedLayers.Add(layerPath, layer);
                            }
                        }
                        catch { Debug.LogError(layerPath + " Encountered a fault"); }

                        SubMat currentLayer;
                        try { currentLayer = loadedLayers[layerPath]; } catch { continue; }

                        Dictionary<int, MatTextureReference> layerTextures = new Dictionary<int, MatTextureReference>();
                        try
                        {
                            string ddnaSearchPath = "";
                            foreach (MatTexture texRef in currentLayer.Textures.Texture)
                            {
                                //Textures: 
                                //Ignore "nearest_cubemap" (This may actually be useful for grabbing from reflection probes)
                                //Ignore "$RenderToTexture" (May be useful for the interactive display screens?)
                                //Special handling case for "$TintPaletteDecal"?  This applies a special decal node that has not yet been transferred over
                                if (texRef.File == null)
                                {
                                    continue;
                                }
                                if (texRef.File.Contains("$RenderToTexture") || texRef.File.Contains("nearest_cubemap") || texRef.File.Contains("$TintPaletteDecal"))
                                {
                                    continue;
                                }
                                if (failedTextures.Contains(texRef.File))
                                {
                                    continue;
                                }
                                MatTextureReference newtex = new MatTextureReference();
                                int texSlot = Convert.ToInt16(texRef.Map.Remove(0, 7));
                                //newtex.textureSlot = Convert.ToInt16(texSlot);
                                //newtex.texturePath = ImportFile(texRef.File, settings);

                                if (texSlot == 3)
                                {
                                    //Debug.LogWarning("Looking for Glossmap: " + texRef.File.ReplaceLast(".", ".glossmap."));
                                    //newtex.texturePath = ImportFile(texRef.File.ReplaceLast(".", ".glossmap."), settings);
                                    //if (newtex.texturePath == "")
                                    //{
                                    //Debug.LogWarning("Failed to find Glossmap, looking for normal ddn: ");
                                    //    newtex.texturePath = ImportFile(texRef.File, settings);
                                    //}

                                    if (!texRef.File.ToLower().Contains(".gloss"))
                                    {
                                        newtex.texturePath = ImportFile(texRef.File.ReplaceLast(".", ".glossmap."), settings);
                                        if (newtex.texturePath == "")
                                        {
                                            //Debug.LogWarning("Failed to find Glossmap, looking for normal ddn: ");
                                            newtex.texturePath = ImportFile(texRef.File, settings);
                                        }
                                    }
                                    else
                                    {
                                        newtex.texturePath = ImportFile(texRef.File, settings);
                                    }
                                }
                                //newtex.textureSlot = texSlot;
                                else { newtex.texturePath = ImportFile(texRef.File, settings); }
                                if (newtex.texturePath == "")
                                {
                                    failedTextures.Add(texRef.File);
                                    continue;
                                }
                                if (texSlot == 2)
                                {
                                    ddnaSearchPath = texRef.File;
                                }
                                if (texRef.TexMod != null)
                                {
                                    newtex.textureTiling = new Vector2(texRef.TexMod.TileU, texRef.TexMod.TileV);
                                }
                                else { newtex.textureTiling = new Vector2(1.0f, 1.0f); }
                                layerTextures.Add(texSlot, newtex);
                            }
                            if (!layerTextures.ContainsKey(3))
                            {
                                if (layerTextures.ContainsKey(2))
                                {
                                    MatTextureReference newTex = new MatTextureReference();
                                    newTex.texturePath = ImportFile(ddnaSearchPath.ReplaceLast(".", ".glossmap."), settings);
                                    if (newTex.texturePath != "")
                                    {
                                        newTex.textureTiling = layerTextures[2].textureTiling;
                                        layerTextures.Add(3, newTex);
                                    }
                                }
                            }
                        }
                        catch { }

                        // try
                        // {
                        //     if (layerTextures.ContainsKey(3))
                        //     {
                        //         if (!layerTextures[3].texturePath.ToLower().Contains(".glossmap"))
                        //         {
                        //             layerTextures[3].texturePath = GenerateGlossMap(layerTextures[3].texturePath, settings);
                        //         }
                        //     }
                        //     else if (layerTextures.ContainsKey(2))
                        //     {
                        //         MatTextureReference newGloss = new MatTextureReference();
                        //         newGloss.textureTiling = layerTextures[2].textureTiling;
                        //         newGloss.texturePath = GenerateGlossMap(layerTextures[2].texturePath, settings);
                        //         layerTextures.Add(3, newGloss);
                        //     }
                        // }
                        // catch { }

                        if (matLayer.Name.ToLower() == "primary" || matLayer.Name.ToLower() == "baselayer1")
                        {
                            try
                            {
                                splitProp = matLayer.TintColor.Split(",");
                                propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), 1.0f);
                                mat.SetColor("_PrimaryTintDiff", propColor);
                                mat.SetColor("_PrimaryTintSpec", propColor);
                            }
                            catch { }
                            try { mat.SetFloat("_PrimaryTintGloss", matLayer.GlossMult); } catch { }

                            try
                            {
                                splitProp = currentLayer.Diffuse.Split(",");
                                propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), 1.0f);
                                mat.SetColor("_DiffuseColor1", propColor);
                            }
                            catch { }

                            try
                            {
                                mat.SetTexture("_Diffuse1", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[1].texturePath));
                                mat.SetTextureScale("_Diffuse1", layerTextures[1].textureTiling);
                            }
                            catch { }

                            try { mat.SetColor("_DDNAColor1", new Color(0.5f, 0.5f, 1.0f, currentLayer.Shininess / 255.0f)); } catch { }
                            try
                            {
                                mat.SetTexture("_ddna1", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[2].texturePath));
                                mat.SetTextureScale("_ddna1", layerTextures[2].textureTiling);
                            }
                            catch { }

                            if (layerTextures.ContainsKey(3))
                            {
                                // if (!layerTextures.ContainsKey(2) || layerTextures[2].texturePath != layerTextures[3].texturePath)
                                // {
                                //     try
                                //     {
                                //         mat.SetTexture("_DDNAGlossmap1", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[3].texturePath));
                                //         mat.SetTextureScale("_DDNAGlossmap1", layerTextures[3].textureTiling);
                                //     }
                                //     catch { }
                                // }
                                // try
                                // {
                                //     mat.SetTexture("_DDNAGlossmap1", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[2].texturePath.ReplaceLast(".", ".glossmap.")));
                                //     mat.SetTextureScale("_DDNAGlossmap1", layerTextures[2].textureTiling);
                                // }
                                // catch { }

                                try
                                {
                                    mat.SetTexture("_DDNAGlossmap1", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[3].texturePath));
                                    mat.SetTextureScale("_DDNAGlossmap1", layerTextures[3].textureTiling);
                                }
                                catch { }
                            }
                            else
                            {
                                try
                                {
                                    mat.SetTexture("_DDNAGlossmap1", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[2].texturePath.ReplaceLast(".", ".glossmap.")));
                                    mat.SetTextureScale("_DDNAGlossmap1", layerTextures[2].textureTiling);
                                }
                                catch { }
                            }

                            try
                            {
                                splitProp = currentLayer.Specular.Split(",");
                                propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), 1.0f);
                                mat.SetColor("_SpecularColor1", propColor);
                            }
                            catch { }
                            try
                            {
                                mat.SetTexture("_Specular1", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[4].texturePath));
                                mat.SetTextureScale("_Specular1", layerTextures[4].textureTiling);
                            }
                            catch { }

                            try
                            {
                                mat.SetTexture("_Detail1", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[6].texturePath));
                                mat.SetTextureScale("_Detail1", layerTextures[6].textureTiling);
                            }
                            catch { }
                            try
                            {
                                mat.SetTexture("_BlendTex1", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[12].texturePath));
                                mat.SetTextureScale("_BlendTex1", layerTextures[12].textureTiling);
                            }
                            catch { }

                            try { mat.SetVector("_UVScale1", new Vector2(matLayer.UVTiling, matLayer.UVTiling)); } catch { }
                            try { mat.SetFloat("_LayerTiling1", Convert.ToSingle(currentLayer.PublicParams["@LayerTiling"])); } catch { }
                            try { mat.SetFloat("_DetailTiling1", Convert.ToSingle(currentLayer.PublicParams["@DetailTiling"])); } catch { }
                        }
                        else if (matLayer.Name.ToLower() == "wear" || matLayer.Name.ToLower() == "wearlayer1")
                        {
                            try
                            {
                                splitProp = matLayer.TintColor.Split(",");
                                propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), 1.0f);
                                mat.SetColor("_SecondaryTintDiff", propColor);
                                mat.SetColor("_SecondaryTintSpec", propColor);
                            }
                            catch { }
                            try { mat.SetFloat("_SecondaryTintGloss", matLayer.GlossMult); } catch { }

                            try
                            {
                                splitProp = currentLayer.Diffuse.Split(",");
                                propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), 1.0f);
                                mat.SetColor("_DiffuseColor2", propColor);
                            }
                            catch { }

                            try
                            {
                                mat.SetTexture("_Diffuse2", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[1].texturePath));
                                mat.SetTextureScale("_Diffuse2", layerTextures[1].textureTiling);
                            }
                            catch { }

                            try { mat.SetColor("_DDNAColor2", new Color(0.5f, 0.5f, 1.0f, currentLayer.Shininess / 255.0f)); } catch { }
                            try
                            {
                                mat.SetTexture("_ddna2", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[2].texturePath));
                                mat.SetTextureScale("_ddna2", layerTextures[2].textureTiling);
                            }
                            catch { }

                            if (layerTextures.ContainsKey(3))
                            {
                                // if (!layerTextures.ContainsKey(2) || layerTextures[2].texturePath != layerTextures[3].texturePath)
                                // {
                                //     try
                                //     {
                                //         mat.SetTexture("_DDNAGlossmap2", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[3].texturePath));
                                //         mat.SetTextureScale("_DDNAGlossmap2", layerTextures[3].textureTiling);
                                //     }
                                //     catch { }
                                // }
                                // try
                                // {
                                //     mat.SetTexture("_DDNAGlossmap2", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[2].texturePath.ReplaceLast(".", ".glossmap.")));
                                //     mat.SetTextureScale("_DDNAGlossmap2", layerTextures[2].textureTiling);
                                // }
                                // catch { }

                                try
                                {
                                    mat.SetTexture("_DDNAGlossmap2", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[3].texturePath));
                                    mat.SetTextureScale("_DDNAGlossmap2", layerTextures[3].textureTiling);
                                }
                                catch { }
                            }
                            else
                            {
                                try
                                {
                                    mat.SetTexture("_DDNAGlossmap2", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[2].texturePath.ReplaceLast(".", ".glossmap.")));
                                    mat.SetTextureScale("_DDNAGlossmap2", layerTextures[2].textureTiling);
                                }
                                catch { }
                            }

                            try
                            {
                                splitProp = currentLayer.Specular.Split(",");
                                propColor = new Color(Convert.ToSingle(splitProp[0]), Convert.ToSingle(splitProp[1]), Convert.ToSingle(splitProp[2]), 1.0f);
                                mat.SetColor("_SpecularColor2", propColor);
                            }
                            catch { }
                            try
                            {
                                mat.SetTexture("_Specular2", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[4].texturePath));
                                mat.SetTextureScale("_Specular2", layerTextures[4].textureTiling);
                            }
                            catch { }

                            try
                            {
                                mat.SetTexture("_Detail2", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[6].texturePath));
                                mat.SetTextureScale("_Detail2", layerTextures[6].textureTiling);
                            }
                            catch { }
                            try
                            {
                                mat.SetTexture("_BlendTex2", AssetDatabase.LoadAssetAtPath<Texture>(layerTextures[12].texturePath));
                                mat.SetTextureScale("_BlendTex2", layerTextures[12].textureTiling);
                            }
                            catch { }

                            try { mat.SetVector("_UVScale2", new Vector2(matLayer.UVTiling, matLayer.UVTiling)); } catch { }
                            try { mat.SetFloat("_LayerTiling2", Convert.ToSingle(currentLayer.PublicParams["@LayerTiling"])); } catch { }
                            try { mat.SetFloat("_DetailTiling2", Convert.ToSingle(currentLayer.PublicParams["@DetailTiling"])); } catch { }
                        }

                        if (currentMat.Shader.ToLower() == "layerblend" || currentMat.Shader.ToLower() == "layerblend_v2")
                        {
                            //Apply remaining material layers
                            //Not currently fully set up to support all 8 layers
                        }
                    }
                }
            }

            //try
            //{
            // Material existingMat = AssetDatabase.LoadAssetAtPath<Material>(targetPath);
            // if (existingMat != null)
            // {
            //     existingMat = new Material(mat);
            //     AssetDatabase.ImportAsset(targetPath, ImportAssetOptions.ForceUpdate);
            //     //continue;
            // }
            //}
            //catch
            //else
            //{
            try
            {
                AssetDatabase.CreateAsset(mat, targetPath);
                //AssetDatabase.ImportAsset(targetPath, ImportAssetOptions.ForceUpdate);
            }
            catch { Debug.LogWarning("Failed to generate material: " + targetPath); }
            //}

        }

        AssetDatabase.Refresh();

        if (failedTextures.Count > 0)
        {
            foreach (string m in failedTextures)
            {
                Debug.LogWarning("Failed to import Texture: " + m);
            }
        }
    }

    private static void AssignMaterialsToScene(GlobalImportSettings settings)
    {
        List<string> failedMaterials = new List<string>();
        int succeededMats = 0;


        foreach (MeshRenderer mesh in settings.targetObject.GetComponentsInChildren<MeshRenderer>())
        {
            //Dictionary<string, Material> newMats = new Dictionary<string, Material>();

            Material[] oldMats = mesh.sharedMaterials;
            List<Material> newMats = new List<Material>();
            for (int i = 0; i < oldMats.Count(); i++)
            {
                string mName = oldMats[i].name.ToLower();
                string targetPath = settings.materialGenerationPath + "/" + mName + ".mat";
                //Material mat = Resources.Load(targetPath, typeof(Material)) as Material;
                Material mat = AssetDatabase.LoadAssetAtPath<Material>(targetPath);
                if (mat != null)
                {
                    newMats.Add(mat);
                    //mesh.sharedMaterials[i] = mat;
                    succeededMats++;
                }
                else
                {
                    failedMaterials.Add(mName + " in Renderer " + mesh.transform.name);
                    newMats.Add(oldMats[i]);
                }

            }

            mesh.SetSharedMaterials(newMats);
        }

        foreach (SkinnedMeshRenderer mesh in settings.targetObject.GetComponentsInChildren<SkinnedMeshRenderer>())
        {
            //Dictionary<string, Material> newMats = new Dictionary<string, Material>();

            Material[] oldMats = mesh.sharedMaterials;
            List<Material> newMats = new List<Material>();
            for (int i = 0; i < oldMats.Count(); i++)
            {
                string mName = oldMats[i].name.ToLower();
                string targetPath = settings.materialGenerationPath + "/" + mName + ".mat";
                //Material mat = Resources.Load(targetPath, typeof(Material)) as Material;
                Material mat = AssetDatabase.LoadAssetAtPath<Material>(targetPath);
                if (mat != null)
                {
                    newMats.Add(mat);
                    //mesh.sharedMaterials[i] = mat;
                    succeededMats++;
                }
                else
                {
                    failedMaterials.Add(mName + " in Renderer " + mesh.transform.name);
                    newMats.Add(oldMats[i]);
                }

            }

            mesh.SetSharedMaterials(newMats);
        }

        Debug.Log("Successfully assigned " + succeededMats + " materials to objects within the scene.");
        if (failedMaterials.Count > 0)
        {
            Debug.LogWarning("Failed to assign the following " + failedMaterials.Count() + " materials:");
            foreach (string fail in failedMaterials)
            {
                Debug.LogWarning(fail);
            }
        }
    }


    #endregion

    #region Light Handling

    private static Dictionary<string, LightContainerReference> CreateLightList(bpContainer bp)
    {

        Dictionary<string, LightContainerReference> allLights = new Dictionary<string, LightContainerReference>();

        foreach (KeyValuePair<string, socContainer> soc in bp.socs)
        {
            foreach (KeyValuePair<string, Dictionary<string, SocLightContainer>> lightgroup in soc.Value.lights)
            {
                foreach (KeyValuePair<string, SocLightContainer> light in lightgroup.Value)
                {
                    LightContainerReference newLight = new LightContainerReference();

                    newLight.lightContainer = light.Value;
                    newLight.lightName = light.Key;
                    newLight.lightGroupName = lightgroup.Key;
                    newLight.socPath = soc.Key;
                    allLights.Add(newLight.lightName, newLight);
                }
            }
        }

        return allLights;

    }

    private static List<GameObject> FindSceneLights(Dictionary<string, LightContainerReference> lights, GameObject sceneParent)
    {
        List<GameObject> matchingLights = new List<GameObject>();

        foreach (Transform t in sceneParent.GetComponentsInChildren<Transform>())
        {
            // foreach (LightContainerReference lightCheck in lights)
            // {
            //     if (lightCheck.lightName == t.name)
            //     {
            //         matchingLights.Add(t.gameObject);
            //         break;
            //     }
            // }
            if (lights.ContainsKey(t.name))
            {
                matchingLights.Add(t.gameObject);
            }
        }

        return matchingLights;
    }


    private static void CreateLightPrefab()
    {
        //create a prefab with children for each light group, if one does not already exist
        //name children based on all lights in the lightgroup
        //If one already exists, select that as the new target object and check that all existing lights are correct
        //pass children into ImportLightData to set their information
    }

    private static void ImportLightData(List<GameObject> sceneLights, Dictionary<string, LightContainerReference> bpLights, GlobalImportSettings globalSettings, LightImportSettings lightSettings)
    {
        //Add some additional buttons and features to set parameters
        //Possible additional overrides:
        //Gamma correction toggle/value
        //Intensity Adjustment
        //Range adjustment
        //"Attempt to simulate physical lights?" 
        //Selector for which light state to pull from; e.g. default, auxilary, emergency, or cinematic
        //right now it just pulls from the default state

        Quaternion defaultRot = new Quaternion(1.0f, 0.0f, 0.0f, 0.0f);

        foreach (GameObject lightObject in sceneLights)
        {
            if (bpLights.ContainsKey(lightObject.name))
            {
                LightContainerReference activeLight = bpLights[lightObject.name];

                Light light = lightObject.GetComponent<Light>();

                if (light == null)
                {
                    light = lightObject.AddComponent<Light>();
                }

                if (lightSettings.fixTransforms)
                {
                    //Searches the containers in the blueprint to find the matching SOC container, which should contain transform information
                    ContainerAttributes attrs = SearchContainers(activeLight.socPath, globalSettings.importedBlueprint.containers);

                    if (attrs == null)
                    {
                        Debug.LogWarning("Failed to find a matching soc in current blueprint for light: " + lightObject.name + ", using default values");
                        attrs = new ContainerAttributes();
                        attrs.pos = new XYZVector();
                        attrs.rotation = new RotationVector();
                        attrs.socpak = activeLight.socPath;
                        attrs.pos.x = 0.0f;
                        attrs.pos.y = 0.0f;
                        attrs.pos.z = 0.0f;
                        attrs.rotation.x = 1.0f;
                        attrs.rotation.y = 0.0f;
                        attrs.rotation.z = 0.0f;
                        attrs.rotation.w = 0.0f;
                    }

                    Vector3 parentPos = new Vector3(attrs.pos.x, attrs.pos.y, attrs.pos.z);
                    Quaternion parentRot = new Quaternion(attrs.rotation.x, attrs.rotation.y, attrs.rotation.z, attrs.rotation.w);

                    string[] getXRot = activeLight.lightContainer.RelativeXForm.rotation.Split(",");
                    string[] getLRot = activeLight.lightContainer.Rotate.Split(",");
                    string[] getXPos = activeLight.lightContainer.RelativeXForm.translation.Split(",");
                    string[] getLPos = activeLight.lightContainer.Pos.Split(",");

                    Quaternion xRotation = new Quaternion(Convert.ToSingle(getXRot[0]), Convert.ToSingle(getXRot[1]), Convert.ToSingle(getXRot[2]), Convert.ToSingle(getXRot[3]));
                    Quaternion lRot = new Quaternion(Convert.ToSingle(getLRot[0]), Convert.ToSingle(getLRot[1]), Convert.ToSingle(getLRot[2]), Convert.ToSingle(getLRot[3]));
                    Vector3 lightPos = new Vector3(Convert.ToSingle(getXPos[0]) + Convert.ToSingle(getLPos[0]), Convert.ToSingle(getXPos[1]) + Convert.ToSingle(getLPos[1]), Convert.ToSingle(getXPos[2]) + Convert.ToSingle(getLPos[2]));
                    Quaternion lightRot = Quaternion.Lerp(lRot, xRotation, 0.5f);

                    light.transform.position = parentPos + lightPos;
                    light.transform.rotation = defaultRot * Quaternion.Lerp(lightRot, parentRot, 0.5f);
                }

                //set light settings from blueprint data here
                //Light type:
                //"Omni" => Point
                //"Projector" => Spot/Area
                //"Planar" => ???? (Is this supposed to actually be area?)

                if (activeLight.lightContainer.EntityComponentLight.lightType == "Omni")
                {
                    light.type = LightType.Point;
                }
                else if (activeLight.lightContainer.EntityComponentLight.lightType == "Projector")
                {
                    light.type = LightType.Spot;
                }
                else
                {
                    light.type = LightType.Rectangle;
                }

                EntityComponentLight entity = activeLight.lightContainer.EntityComponentLight;
                LightState state = entity.defaultState;

                //Select state to use as a reference point
                switch (lightSettings.state)
                {
                    case LightStateName.Auxilary:
                        state = entity.auxilaryState;
                        break;
                    case LightStateName.Emergency:
                        state = entity.emergencyState;
                        break;
                    case LightStateName.Cinematic:
                        state = entity.cinematicState;
                        break;
                    default:
                        state = entity.defaultState;
                        break;
                }

                //Set Color and perform gamma correction
                Color targetColor = new Color(state.color.r, state.color.g, state.color.b, 1.0f);
                light.color = targetColor.gamma;

                //Set intensity. Currently no correction to attempt to approximate the physical-based units of StarEngine
                light.intensity = state.intensity;

                //Color Temperature
                light.useColorTemperature = Convert.ToBoolean(entity.useTemperature);
                light.colorTemperature = state.temperature;

                //range
                if (entity.fadeParams != null && Convert.ToSingle(entity.fadeParams["@maxDistance"]) != 0)
                {
                    light.range = Convert.ToSingle(entity.fadeParams["@maxDistance"]);
                }
                else
                {
                    light.range = entity.sizeParams.lightRadius;
                }
                
                if (entity.projectorParams.ContainsKey("@FOV"))
                {
                    light.spotAngle = Convert.ToSingle(entity.projectorParams["@FOV"]);
                }
                //Set dilatedRange for Area lights?

                //Set Area size
                light.areaSize = new Vector2(entity.sizeParams.planeWidth, entity.sizeParams.planeHeight);
                //Do we need to set transform scale for spotlights? Not sure that it actually affects anything

                //Set Shadow Settings
                if (entity.shadowParams["@shadowCasting"] == "1")
                {
                    light.shadows = LightShadows.Hard;
                }
                else
                {
                    light.shadows = LightShadows.None;
                }

                //cookie settings
                string cookieName = entity.projectorParams["@texture"];
                if (cookieName != "")
                {
                    if (light.type == LightType.Point)
                    {
                        cookieName = ImportFile(cookieName, globalSettings, true, true);
                    }
                    else
                    {
                        cookieName = ImportFile(cookieName, globalSettings, true);
                    }

                    if (cookieName != "")
                    {
                        Texture cookie = (Texture)AssetDatabase.LoadMainAssetAtPath(cookieName);
                        light.cookie = cookie;
                    }
                }
            }
        }
    }

    private static ContainerAttributes SearchContainers(string searchString, Dictionary<string, ContainerInstance> containers)
    {
        ContainerAttributes attrs = null;
        foreach (ContainerInstance containerCheck in containers.Values)
        {
            if (containerCheck.containers.Count > 0)
            {
                attrs = SearchContainers(searchString, containerCheck.containers);
            }

            if (attrs == null)
            {
                if (containerCheck.socs.Contains(searchString))
                {
                    return containerCheck.attrs;
                }
            }
            else
            {
                return attrs;
            }
        }
        return attrs;
    }

    #endregion


    #endregion

}

#endif
